module FeatureCreators


abstract type AbstractFeatureCreator end

function create_features(fc::AbstractFeatureCreator, s; kwargs...)
    throw("Implement create features for $(typof(fc))")
end


export TileCoder
include("FeatureCreators/TileCoder.jl")

export KenervaCoder
include("FeatureCreators/KenervaCoder.jl")


end
