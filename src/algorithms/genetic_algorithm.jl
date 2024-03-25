using .Models: State, Veichle, Population, PackagesStream

using Random
using StatsBase

function genetic_algorithm(init_population::Population, max_generations::Int64 = 100, elitism_population_size::Int64 = 20, mutation_rate::Float64 = 0.01)

    veichle_vel = init_population.individuals[1].veichle_velocity
    population_size = length(init_population.individuals)
    population = copy(init_population)

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
            #println("Parent1: ", parents[1].total_distance)
            #println("Parent2: ", parents[2].total_distance)

            # Crossover 
            #TODO: Use the choosing algorithm
            child = one_point_crossover(parents[1], parents[2])

            # Mutation
            if rand(Uniform(0, 1)) < mutation_rate
                #TODO: Something here is adding packages because when running the alg with mutation the number of packages increases
                mutate!(child)
            end

            push!(new_population, State(child, Veichle(0, 0, veichle_vel)))
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
    crossover_point = rand(1:length(parent1.packages_stream))

    child1 = copy(parent1.packages_stream[1:crossover_point])
    for package in parent2.packages_stream
        if !(package in child1)
            push!(child1, package)
        end
    end

    return child1
end

# TODO: Fix or remove this
function multi_point_crossover(parent1::State, parent2::State, num_points::Int)
    child1 = copy(parent1)
    child2 = copy(parent2)

    crossover_points = rand(1:parent1.size, num_points)
    sort!(crossover_points)
    num_segments = num_points + 1
    last_cut = 1
    for i in 1:num_segments
        cut_point = crossover_points[i]
        if i % 2 == 0
            child1.packages[last_cut:cut_point], child2.packages[last_cut:cut_point] = child2.packages[last_cut:cut_point], child1.packages[last_cut:cut_point]
        end
        last_cut = cut_point + 1
    end

    return best_child(child1, child2, parent1, parent2)
end

# TODO: Fix or remove this
function uniform_crossover(parent1::PackagesStream, parent2::PackagesStream)
    child1 = copy(parent1)
    child2 = copy(parent2)
    
    for i in 1:parent1.size
        if rand() < 0.5
            child1.packages[i], child2.packages[i] = child2.packages[i], child1.packages[i]
        end
    end
    return best_child(child1, child2, parent1, parent2)
end

# Mutation function
function mutate!(packages::Array{Package, 1})
    i, j = rand(1:length(packages), 2)
    packages[i], packages[j] = packages[j], packages[i]
end

