
using LinearAlgebra

# Module for tilecoding functionality
include("utilities/TileCoding.jl")

abstract type AbstractTileCoder <: AbstractFeatureCreator
end
abstract type AbstractHashlessTileCoder <: AbstractTileCoder
end

"""
    TileCoder(num_tilings, num_tiles, num_features, num_ints)
Tile coder for coding all features together. Returns active indices.
"""
mutable struct TileCoder <: AbstractTileCoder
    # Main Arguments
    num_tilings::Int64
    num_tiles::Int64
    num_features::Int64
    num_ints::Int64

    # Optional Arguments
    wrap::Bool
    wrapwidths::Float64

    iht::TileCoding.IHT
    TileCoder(num_tilings, num_tiles, num_features, num_ints=1; wrap=false, wrapwidths=0.0) =
        new(num_tilings, num_tiles, num_features, num_ints, wrap, 0.0, TileCoding.IHT(num_tilings*(num_tiles+1)^num_features * num_ints))
end

function _create_features(fc::AbstractTileCoder, s; ints=[], readonly=false)
    if fc.wrap
        return 1 .+ TileCoding.tileswrap!(fc.iht, fc.num_tilings, s.*fc.num_tiles, fc.wrapwidths, ints, readonly)
    else
        return 1 .+ TileCoding.tiles!(fc.iht, fc.num_tilings, s.*fc.num_tiles, ints, readonly)
    end
end

function create_features(fc::TileCoder, s; ints=[], readonly=false)
    return _create_features(fc, s, ints, readonly)
end

feature_size(fc::TileCoder) = fc.num_tilings


"""
    TileCoderFull(num_tilings, num_tiles, num_features, num_ints)
Tile coder for coding all features together. Returns full binary array.
"""
mutable struct TileCoderFull <: AbstractTileCoder
    # Main Arguments
    num_tilings::Int64
    num_tiles::Int64
    num_features::Int64
    num_ints::Int64

    # Optional Arguments
    wrap::Bool
    wrapwidths::Float64

    iht::TileCoding.IHT
    TileCoderFull(num_tilings, num_tiles, num_features, num_ints=1; wrap=false, wrapwidths=0.0) =
        new(num_tilings, num_tiles, num_features, num_ints, wrap, 0.0, TileCoding.IHT(num_tilings*(num_tiles+1)^num_features * num_ints))
end

function create_features(fc::TileCoderFull, s; ints=[], readonly=false)
    x = zeros(Int8, fc.iht.size)
    x[_create_features(fc, s, ints, readonly)] = 1
    return x
end

feature_size(fc::TileCoderFull) = fc.iht.size

hashlesstilecoder_args(tiles_per_dim::Vector{<:Integer},
                       bounds_per_dim::Matrix{<:Real},
                       num_tilings::Integer;
                       wrap::Union{AbstractVector{Bool}, Nothing}=nothing,
                       offset= n -> collect(1:2:2*n-1) # 1st n odd nums
                       ) = begin
    n = length(tiles_per_dim)

    # these normalize the ith input float to be between 0 and dim[i] + 1
    limits = bounds_per_dim
    norm_dims = tiles_per_dim ./ (limits[2, :] .- limits[1, :])

    # wrapping means not adding 1 to the ith dim
    if wrap == nothing
        bonus = ones(Bool, n)
    else
        bonus = .!wrap
    end
    wrap_any_dims = any(.!bonus)
    tiling_dims = tiles_per_dim + bonus

    # displacement matrix; default is assymetric displacement a la Parks
    # and Militzer https://doi.org/10.1016/S1474-6670(17)54222-6
    offset_vec = offset(n)
    offsets = (offset_vec
               .* hcat([collect(0:num_tilings-1) for _ in 1:n]...)'
               / num_tilings
               .% 1)

    # these send each displaced float to the proper index
    tiling_loc = collect(0:num_tilings-1) .* prod(tiling_dims)
    tile_loc = [prod(tiling_dims[1:i-1]) for i in 1:n]

    # the total number of indices needed
    num_features = num_tilings * prod(tiling_dims)
    num_active_features = num_tilings

    return (limits, norm_dims, tiling_dims, wrap_any_dims, offsets, tiling_loc,
            tile_loc, num_features, num_active_features)
end

mutable struct HashlessTileCoder <: AbstractHashlessTileCoder
    limits::Matrix{Float64}
    norm_dims::Vector{Float64}
    tiling_dims::Vector{UInt32}
    wrap_any_dims::Bool
    offsets::Matrix{Float64}
    tiling_loc::Vector{UInt}
    tile_loc::Vector{UInt}
    num_features::UInt
    num_active_features::UInt

    function HashlessTileCoder(a...;k...)
        l, n, t, w, o, tgl, til, nf, naf = hashlesstilecoder_args(a...;k...)
        new(l, n, t, w, o, tgl, til, nf, naf)
    end
end

feature_size(fc::T) where {T<:HashlessTileCoder} = fc.num_features

function _create_features(fc::T, s) where {T<:AbstractHashlessTileCoder}
    if fc.wrap_any_dims
        # wrapping means modding by dim[i] instead of dim[i] + 1
        off_coords = map(x -> floor(Int, x),
                         ((s .- fc.limits[1, :])
                          .* fc.norm_dims
                          .+ fc.offsets)
                         .% fc.tiling_dims)
    else
        # don't need to mod here, because dim[i] + 1 is bigger than the
        # displaced floats
        off_coords = map(x -> floor(Int, x),
                         (s .- fc.limits[1, :]) .* fc.norm_dims .+ fc.offsets)
    end
    return fc.tiling_loc .+ off_coords' * fc.tile_loc .+ 1
end
create_features(fc::HashlessTileCoder, s) = _create_features(fc, s)

mutable struct HashlessTileCoderFull <: AbstractHashlessTileCoder
    limits::Matrix{Float64}
    norm_dims::Vector{Float64}
    tiling_dims::Vector{UInt32}
    wrap_any_dims::Bool
    offsets::Matrix{Float64}
    tiling_loc::Vector{UInt}
    tile_loc::Vector{UInt}
    num_features::UInt

    function HashlessTileCoderFull(a...;k...)
        l, n, t, w, o, tgl, til, nf = hashlesstilecoder_args(a...;k...)
        new(l, n, t, w, o, tgl, til, nf)
    end
end
feature_size(fc::T) where {T<:HashlessTileCoderFull} = fc.num_features


function create_features(fc::HashlessTileCoderFull, s)
    x = zeros(fc.num_features)

    x[_create_features(fc, s)] .= 1

    return x
end
