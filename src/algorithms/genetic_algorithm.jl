using .Models: State, Veichle, Population, PackagesStream

using Random
using StatsBase

function generate_population(state::State, population_size::Int64)
    return Population([State(shuffle(state.packages_stream), Veichle(0, 0, state.veichle_velocity)) for _ in 1:population_size])
end

function genetic_algorithm(state::State, population_size::Int64 = 50, max_generations::Int64 = 100, elitism_population_size::Int64 = 20, mutation_rate::Float64 = 0.01)
    population = generate_population(state, population_size)

    for i in 1:max_generations
        println("Generation: ", i)

        # New Population
        new_population = []

        # Elitism - Copying the best individuals to the next generation without any change to help preserve the best solution.
        elitism_population = population.individuals
        sort!(elitism_population, by=fitness, rev=true)
        # without a for put the best elitism_population_size individuals in the new population 
        new_population = elitism_population[1:elitism_population_size]

        # Reproduction
        for i in 1:(population_size - elitism_population_size)
            # Selection 
            #TODO: Use the choosing algorithm
            parents = tournament_selection(population)
            #parents = roulette_wheel_selection(population)
            #parents = rank_based_selection(population)

            # Crossover 
            #TODO: Use the choosing algorithm
            child = one_point_crossover(parents[1], parents[2])
            #child = multi_point_crossover(parents[1], parents[2], 5)
            #child = uniform_crossover(parents[1], parents[2])

            # Mutation
            if rand(Uniform(0, 1)) < mutation_rate
                mutate!(child)
            end

            push!(new_population, State(child, Veichle(0, 0, state.veichle_velocity)))
        end

        population = Population(new_population)
    end

    return sort(population.individuals, by=fitness, rev=true)[1]
end

#=

SELECTION FUNCTIONS
- Tournament selection
- Roulette wheel selection
- Rank-based selection

Our selection functions returns two diference parents. 
This is an optimization step since we want diversity and 
the best individuals were already copied to the next 
generation with the elistm selection.

=#

# Two random parents
function select_random_from_population(population::Population)
    return sample(population.individuals, 2, replace=false)
end

function tournament_selection(population::Population, tournament_size::Int = 5)
    tournament = sample(population.individuals, tournament_size, replace=false)
    sort!(tournament, by=fitness, rev=true)
    return tournament[1:2]
end

# This algorithm takes a lot of time to run
function roulette_wheel_selection(population::Population)
    fitness_values = abs.([fitness(individual) for individual in population.individuals])
    total_fitness = sum(fitness_values)
    probabilities = fitness_values / total_fitness
    
    return sample(population.individuals, Weights(probabilities), 2, replace=false)[1:2]
end

function rank_based_selection(population::Population)
    fitness_values = [fitness(individual) for individual in population.individuals]
    sorted_indices = sortperm(fitness_values)
    ranks = length(sorted_indices):-1:1
    total_ranks = sum(abs.(ranks))
    probabilities = abs.(ranks) / total_ranks
    
    return sample(population.individuals, Weights(probabilities), 2, replace=false)[1:2]
end

#=

CROSSOVER FUNCTIONS
- One-point crossover
- Multi-point crossover
- Uniform crossover

=#

function one_point_crossover(parent1::State, parent2::State)
    stream_size = length(parent1.packages_stream)
    crossover_point = rand(1:stream_size)

    child1 = copy(parent1.packages_stream[1:crossover_point])
    for package in parent2.packages_stream
        if !(package in child1)
            push!(child1, package)
        end
    end

    return child1
end

function multi_point_crossover(parent1::State, parent2::State, num_points::Int)
    stream_size = length(parent1.packages_stream)
    crossover_points = rand(1:stream_size, num_points)
    sort!(crossover_points)

    child::Array{Union{Package, Missing}, 1} = fill(missing, stream_size)
    
    last_cut = 1
    for i in 1:num_points
        cut_point = crossover_points[i]
        if i % 2 != 0
            child[last_cut:cut_point] = parent1.packages_stream[last_cut:cut_point]
        end
        last_cut = cut_point + 1
    end

    child_packages = filter(x -> !ismissing(x), child)
    resting_packages = filter(x -> x ∉ child_packages, parent2.packages_stream)

    for i in 1:stream_size
        if child[i] === missing
            child[i] = resting_packages[1]
            deleteat!(resting_packages, 1)
        end
    end

    final_child::Array{Package, 1} = [x for x in child if x !== missing]
    return final_child

end

function uniform_crossover(parent1::State, parent2::State)
    stream_size = length(parent1.packages_stream)
    child::Array{Union{Package, Missing}, 1} = fill(missing, stream_size)
    
    for i in 1:stream_size
        if rand() < 0.5
            child[i] = parent1.packages_stream[i]
        end
    end

    chill_packages = filter(x -> !ismissing(x), child)
    resting_packages = filter(x -> x ∉ chill_packages, parent2.packages_stream)

    for i in 1:stream_size
        if child[i] === missing
            child[i] = resting_packages[1]
            deleteat!(resting_packages, 1)
        end
    end

    final_child::Array{Package, 1} = [x for x in child if x !== missing]
    return final_child
end

# Mutation function
function mutate!(packages::Array{Package, 1})
    i, j = rand(1:length(packages), 2)
    packages[i], packages[j] = packages[j], packages[i]
end

