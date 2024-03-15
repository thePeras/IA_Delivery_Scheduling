function genetic_algorithm(init_population::Population, max_generations::Int64 = 100, elitism_population_size::Int64 = 20, mutation_rate::Float64 = 0.01)

    population_size = length(init_population.individuals)
    population = clone(init_population)

    for _ in 1:max_generations
        # New Population
        new_population = []

        # Elitism - Copying the best individuals to the next generation without any change to help preserve the best solution.
        sorted_population = sort(population.individuals, by=fitness)
        new_population = sorted_population[1:elitism_population_size]

        # Reproduction
        for _ in 1:population_size - elitism_population_size
            # Selection TODO: Use the choosing algorithm
            parent1 = select_from_population(population)
            parent2 = select_from_population(population)

            # Crossover TODO: Use the choosing algorithm
            child = crossover(parent1, parent2)

            # Mutation
            if rand(Uniform(0, 1)) < mutation_rate
                mutate!(child)
            end

            push!(new_population, State(child))
        end

        population = Population(new_population)
    end
end

#=

SELECTION FUNCTIONS
- Tournament selection
- Roulette wheel selection
- Rank-based selection
=#

# Random one
function select_from_population(population::Population)
    return population.individuals[rand(1:length(population.individuals))]
end

function tournament_selection(population::Population, tournament_size::Int = 5)
    selected_parents = []
    shuffled_population = shuffle(population.individuals)
    for _ in 1:2 
        tournament = sample(shuffled_population, tournament_size, replace=false)
        winner = argmax([fitness(individual) for individual in tournament])
        push!(selected_parents, tournament[winner])
        # ASK: Should we remove the winner from the shuffled_population?
    end
    return selected_parents
end

# TODO: fitness is better when is lower, so we need to modify the fitness function
function roulette_wheel_selection(population::Population)
    total_fitness = sum([fitness(individual) for individual in population.individuals])
    selected_parents = []
    for _ in 1:2  # Select 2 parents
        r = rand() * total_fitness
        cumulative_fitness = 0.0
        for individual in population.individuals
            cumulative_fitness += fitness(individual)
            if cumulative_fitness >= r
                push!(selected_parents, individual)
                break
            end
        end
    end
    return selected_parents
end

function rank_based_selection(population::Population)
    sorted_population = sort(population.individuals, by=fitness)
    ranks = reverse(1:length(sorted_population))
    probabilities = [r / sum(ranks) for r in ranks]
    selected_parents = []
    for _ in 1:2  # Select 2 parents
        r = rand()
        cumulative_prob = 0.0
        for (individual, prob) in zip(sorted_population, probabilities)
            cumulative_prob += prob
            if cumulative_prob >= r
                push!(selected_parents, individual)
                break
            end
        end
    end
    return selected_parents
end

#=

CROSSOVER FUNCTIONS
- One-point crossover
- Multi-point crossover
- Uniform crossover

=#

function best_child(child1::PackagesStream, child2::PackagesStream, parent1::State, parent2::State)
    fix_duplicates!(child1, parent1)
    fix_duplicates!(child2, parent2)

    fitness1 = fitness(State(child1))
    fitness2 = fitness(State(child2))

    return ifelse(fitness1 > fitness2, child1, child2)
end

function fix_duplicates!(child::PackagesStream, parent::State)
    for package in parent.packages_stream
        if !(package in child.packages)
            idx = findfirst(x -> x == package, child.packages)
            child.packages[idx] = package
        end
    end
end

# Crossover function: Can be one-point, multi-point, Davis Order Crossover (OX1), uniform, Whole Arithmetic Recombination
function one_point_crossover(parent1::State, parent2::State)
    child1 = PackagesStream(parent1.packages_stream)
    child2 = PackagesStream(parent2.packages_stream)

    crossover_point = rand(1:parent1.size)
    for i in 1:crossover_point
        child1.packages[i], child2.packages[i] = child2.packages[i], child1.packages[i]
    end

    return best_child(child1, child2, parent1, parent2)
end

function multi_point_crossover(parent1::State, parent2::State, num_points::Int)
    child1 = copy(parent1)
    child2 = copy(parent2)

    crossover_points = sort(rand(1:parent1.size, num_points))
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
function mutate!(individual::PackagesStream)
    n = length(individual.packages)
    i, j = rand(1:n), rand(1:n)
    individual.packages[i], individual.packages[j] = individual.packages[j], individual.packages[i]
end

