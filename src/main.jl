using Distributions

include("menu.jl")
include("models.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")

using .Models: State, Package, Veichle
using .Menu: choose_menu

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

    choice = choose_menu()
    algorithm, iterations = choice

    if algorithm == "Hill Climbing"
        current_state = hill_climbing(state, iterations)
    elseif algorithm == "Simulated Annealing"
        current_state = simulated_annealing(state, max_iterations=iterations)
    end

    println(current_state.total_time)
end

main()
