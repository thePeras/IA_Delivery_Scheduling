struct Population
    individuals::Array{PackagesStream}
end

function genetic_algorithm(state::State, max_generations::Int64 = 100, population_size::Int64 = 20, mutation_rate::Float64 = 0.01)

    # Generate the initial population

    # Iterate the population_size
    for _ in 1:population_size
        # Generate a random individual
        individual = generate_random_individual(state)
        push!(population.individuals, individual)
    end

end

# Select from population function
# TODO: Modify this function
function select_from_population(population::Population)
    return population.individuals[rand(1:length(population.individuals))]
end

# Crossover function
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

