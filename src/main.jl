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

function generate_population(population_size::Int64, packages_size::Int64, map_size::Int64, veichle::Veichle = Veichle(0, 0, 60))
    individuals = []
    for _ in 1:population_size
        push!(individuals, generate_package_stream(packages_size, map_size))
    end
    new_individuals = [State(individual, veichle) for individual in individuals]
    return Population(new_individuals)
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
    velocity = 60 # 60 km/h

    packages_stream = generate_package_stream(num_packages, map_size)
    state::State = State(packages_stream, Veichle(0, 0, velocity))

    # Testing  GA
    init_population = generate_population(50, num_packages, map_size, Veichle(0, 0, velocity))
    current_state = genetic_algorithm(init_population, 1000, 20, 0.2)
    # check if exist repeated packages in current_state
    for i in 1:length(current_state.packages_stream)
        for j in 1:length(current_state.packages_stream)
            if i != j
                if current_state.packages_stream[i] == current_state.packages_stream[j]
                    println("Repeated packages")
                end
            end
        end
    end

    # print number of packages in current_state
    print("Number of Packages: ")
    println(length(current_state.packages_stream))
    
    print("GA: ")
    println(current_state.total_time)

    current_state = hill_climbing(state, 1000)
    print("Hill Climbing: ")
    println(current_state.total_time)

    current_state = simulated_annealing(state, max_iterations=1000)
    print("Simulated Annealing: ")
    println(current_state.total_time)
    return

    algorithm, iterations = choose_menu()

    if algorithm == "Hill Climbing"
        current_state = hill_climbing(state, iterations)
    elseif algorithm == "Simulated Annealing"
        current_state = simulated_annealing(state, max_iterations=iterations)
    elseif algorithm == "Genetic Algorithm"
        #init_population = generate_population(20)
        #current_state = genetic_algorithm(init_population, iterations)
    end

    println(current_state.total_time)
end

main()
