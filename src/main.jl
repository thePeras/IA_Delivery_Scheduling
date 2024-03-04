
using Distributions

include("models.jl")
include("algorithms/hill_climbing.jl")

using .Models: State, Package, Veichle

function generate_package_stream(num_packages, map_size)
    types = ["fragile", "normal", "urgent"]
    return Dict(i => Package(
                i,
                rand(types),
                rand(Uniform(0, map_size)),
                rand(Uniform(0, map_size)),
            ) for i in 1:num_packages)
end

function main()
    num_packages = 15
    map_size = 60
    velocity = 60 # 60 km/h
    state = State(generate_package_stream(num_packages, map_size))

    best_solution = hill_climbing()
end

main()
