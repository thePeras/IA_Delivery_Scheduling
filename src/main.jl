using Distributions

include("menu.jl")
include("models.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")
include("algorithms/tabu_search.jl")

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

function fitness(state::State)
    #=
        1. Distance Cost: C * distance
        2. Damage Cost: Z * n_breaked_packages // Calculated in the State constructor
        3. Urgente Cost: C * total_late_minutes
    =#
    
    C = 0.3
    distance_cost = C * state.total_distance
    urgent_cost = C * state.total_late_minutes
    return - (distance_cost + state.broken_packages_cost + urgent_cost)
end

function main()
    num_packages = 100
    map_size = 60
    velocity = 60 # km⋅h⁻¹

    packages_stream = generate_package_stream(num_packages, map_size)
    
    running = true
    while running
        state::State = State(packages_stream, Veichle(0, 0, velocity))
        algorithm, iterations = choose_menu()

        if algorithm == "Hill Climbing"
            current_state = hill_climbing(state, iterations)
        elseif algorithm == "Simulated Annealing"
            current_state = simulated_annealing(state, max_iterations=iterations)
        elseif algorithm == "Genetic Algorithm"
            current_state = genetic_algorithm(state, 50, iterations)
        elseif algorithm == "Tabu Search"
            current_state = tabu(state, iterations)
        end

        #print the order of the packages
        for package in current_state.packages_stream
            print(package.id, " ")
        end
        println()
    
        println(current_state.total_time)
        println()
        println()

    end
end

main()

