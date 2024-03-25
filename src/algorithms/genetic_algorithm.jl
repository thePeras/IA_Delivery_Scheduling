using .Models: State, Veichle, Population, PackagesStream

using Random

function genetic_algorithm(init_population::Population, max_generations::Int64 = 100, elitism_population_size::Int64 = 20, mutation_rate::Float64 = 0.01)

    veichle_vel = init_population.individuals[1].veichle_velocity
    population_size = length(init_population.individuals)
    population = copy(init_population)

    for i in 1:max_generations
        println("Generation: ", i)

        # New Population
        new_population = []

        # Elitism - Copying the best individuals to the next generation without any change to help preserve the best solution.
        sorted_population = sort(population.individuals, by=fitness)
        reverse!(sorted_population)
        for j in 1:elitism_population_size
            push!(new_population, sorted_population[j])
        end

        # Reproduction
        for _ in 1:(population_size - elitism_population_size)
            # Selection 
            #TODO: Use the choosing algorithm
            parents = tournament_selection(population)
            #parents = roulette_wheel_selection(population)
            #parents = rank_based_selection(population)

            # Crossover 
            #TODO: Use the choosing algorithm
            child = one_point_crossover(parents[1], parents[2])

            # Mutation
            if rand(Uniform(0, 1)) < mutation_rate
                #TODO: Something here is adding packages because when running the alg with mutation the number of packages increases
                mutate!(child)
            end

            push!(new_population, State(child.packages, Veichle(0, 0, veichle_vel)))
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
    shuffled_population = shuffle(population.individuals)
    tournament = sample(shuffled_population, tournament_size, replace=false)
    return sort(tournament, by=fitness, rev=true)[1:2]
end

#FIX: This takes a lot
function roulette_wheel_selection(population::Population)
    total_fitness = abs(sum(fitness(individual) for individual in population.individuals))
    selected_parents = []
    for _ in 1:2 
        r = rand() * total_fitness # Spinning the wheel
        cumulative_fitness = 0.0
        for individual in population.individuals
            if individual in selected_parents
                continue
            end
            cumulative_fitness += abs(fitness(individual))
            if cumulative_fitness >= r
                push!(selected_parents, individual)
                total_fitness -= abs(fitness(individual)) # Update the total fitness because this individual will not considered anymore
                break
            end
        end
    end
    return selected_parents
end

# Fix this 
function rank_based_selection(population::Population)
    sorted_population = sort(population.individuals, by=fitness)
    ranks = reverse(1:length(sorted_population))
    total_ranks = abs(sum(ranks))
    probabilities = [abs(r) / total_ranks for r in ranks]
    selected_parents = []
    
    for _ in 1:2  # Select 2 parents
        r = rand()
        cumulative_prob = 0.0
        for (individual, prob) in zip(sorted_population, probabilities)
            if individual in selected_parents
                continue
            end
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

function one_point_crossover(parent1::State, parent2::State)
    crossover_point = rand(1:length(parent1.packages_stream))

    child1 = copy(parent1.packages_stream[1:crossover_point])
    for package in parent2.packages_stream
        if !(package in child1)
            push!(child1, package)
        end
    end

    return PackagesStream(child1)
end

# TODO: Fix this
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

# TODO: Fix this
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

