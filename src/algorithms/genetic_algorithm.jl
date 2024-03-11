struct Population
    individuals::Array{PackagesStream}
end

function genetic_algorithm(state::State, max_generations::Int64 = 100, population_size::Int64 = 20, mutation_rate::Float64 = 0.01)

    # Generate the initial population
    population = generate_population(population_size)

    # Iterate the population_size
    for _ in 1:population_size
        # Calculate Population fitness?

        # Reproduction
        new_population = []
        # TODO: We can use elitism selection:
        # Copying the best chromosomes from the current population (based on their fitness) to the next generation without 
        # crossover or mutation.
        # This helps ensure that the best solutions are not lost during the reproduction process. 
        for _ in 1:population_size
            parent1 = select_from_population(population)
            parent2 = select_from_population(population)
            child1, child2 = crossover(parent1, parent2)

            # Mutation
            if rand(Uniform(0, 1)) < mutation_rate
                mutate(child1)
            end
            if rand(Uniform(0, 1)) < mutation_rate
                mutate(child2)
            end

            push!(new_population, child1)
            push!(new_population, child2)
        end

        # calculate the fitness of the new population
        
    end

end

# Select from population function
# TODO: Modify this function: Tournament selection, Roulette wheel selection, Rank-based selection
function select_from_population(population::Population)
    return population.individuals[rand(1:length(population.individuals))]
end

# Crossover function: Can be one-point, multi-point, Davis Order Crossover (OX1), uniform, Whole Arithmetic Recombination
function crossover(parent1::PackagesStream, parent2::PackagesStream)
    n = length(parent1.packages)
    crossover_point = rand(1:n)
    child1 = copy(parent1)
    child2 = copy(parent2)
    for i in 1:crossover_point
        child1.packages[i], child2.packages[i] = child2.packages[i], child1.packages[i]
    end

    #return the best child
    return child1, child2
end

# Mutation function
function mutate(individual::PackagesStream)
    n = length(individual.packages)
    i, j = rand(1:n), rand(1:n)
    individual.packages[i], individual.packages[j] = individual.packages[j], individual.packages[i]
    return individual
end

