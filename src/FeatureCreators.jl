module FeatureCreators


abstract type AbstractFeatureCreator end

export TileCoder
include("FeatureCreators/TileCoder.jl")

export KenervaCoder
include("FeatureCreators/KenervaCoder.jl")


end
