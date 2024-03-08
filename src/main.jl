using Distributions

include("models.jl")
include("algorithms/hill_climbing.jl")

using .Models: State, Package, Veichle

function generate_package_stream(num_packages, map_size)
    types = ["fragile", "normal", "urgent"]
    return [Package(
                i,
                rand(types),
                rand(Uniform(0, map_size)),
                rand(Uniform(0, map_size)),
            ) for i in 1:num_packages]
end

function main()
    num_packages = 100
    map_size = 60
    velocity = 60 # 60 km/h

    packages_stream = generate_package_stream(num_packages, map_size)
    state::State = State(packages_stream, Veichle(0, 0, velocity))

    current_state = hill_climbing(state)
    println(current_state.total_time)
end

main()
