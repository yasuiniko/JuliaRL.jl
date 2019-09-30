module FeatureCreators

export AbstractFeatureCreator, create_features, feature_size

"""
    AbstractFeatureCreator
An abstract feature creator, for feature transformation from the states.
"""
abstract type AbstractFeatureCreator end

"""
    create_features(fc::AbstractFeatureCreator, s)
Actually create the features
"""
function create_features(fc::AbstractFeatureCreator, s; kwargs...)
    throw("Implement create features for $(typeof(fc))")
end

"""
    feature_size(fc::AbstractFeatureCreator)
Get size of feature vector the features assume exists.
"""
function feature_size(fc::AbstractFeatureCreator)
    throw("Implement feature size for $(typeof(fc))")
end


export TileCoder, TileCoderFull
include("FeatureCreators/TileCoder.jl")

export KenervaCoder
include("FeatureCreators/KenervaCoder.jl")


end
