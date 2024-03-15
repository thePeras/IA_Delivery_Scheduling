using Distributions

include("menu.jl")
include("models.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")

using .Models: State, Package, Veichle, Population
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

function generate_population(population_size::Int64)
    individuals = []
    for _ in 1:population_size
        push!(individuals, generate_package_stream(10, 100))
    end
    return Population(individuals)
end

function main()
    num_packages = 100
    map_size = 60
    velocity = 60 # 60 km/h

    packages_stream = generate_package_stream(num_packages, map_size)
    state::State = State(packages_stream, Veichle(0, 0, velocity))

    algorithm, iterations = choose_menu()

    if algorithm == "Hill Climbing"
        current_state = hill_climbing(state, iterations)
    elseif algorithm == "Simulated Annealing"
        current_state = simulated_annealing(state, max_iterations=iterations)
    elseif algorithm == "Genetic Algorithm"
        init_population = generate_population(20)
        current_state = genetic_algorithm(init_population, iterations)
    end

    println(current_state.total_time)
end

main()
