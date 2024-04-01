using .Models: State, Package, Veichle

#=
    Tabu Search algorithm to solve the Delivery Schedule Optimization Problem.
    - state: Initial state of the problem
    - max_iterations: Maximum number of iterations to run the algorithm
    - max_tabu_size: Maximum number of states to store in the tabu list
    - nNeighbors: Number of neighbors to generate in each iteration

    Returns the best state found by the Tabu Search algorithm.
=#
function tabu(state::State, max_iterations::Int64 = 100, max_tabu_size::Int64 = 10, nNeighbors::Int64 = 10)
    current_iteration = 0
    best_state = state
    best_candidate = state
    tabu_list = []
    push!(tabu_list, state)

    while (current_iteration < max_iterations)
        neighborhood = get_neighbors(best_candidate, nNeighbors)
        best_candidate_fitness = -Inf
        
        for candidate in neighborhood
            if !(candidate in tabu_list) && fitness(candidate) > best_candidate_fitness
                best_candidate = candidate
                best_candidate_fitness = fitness(best_candidate)
            end
        end
        if best_candidate_fitness == -Inf
            break
        end
        if fitness(best_candidate) > fitness(best_state)
            best_state = best_candidate
        end
        push!(tabu_list, best_candidate)
        if length(tabu_list) > max_tabu_size
            popfirst!(tabu_list)
        end

        current_iteration += 1
    end

    return best_state
end

function get_neighbors(state::State, nNeighbors::Int64 = 10)
    n = length(state.packages_stream)
    neighbors = []
    pairs = generate_random_pairs(n, nNeighbors)

    for (i, j) in pairs
        new_stream = copy(state.packages_stream)
        new_stream[i], new_stream[j] = new_stream[j], new_stream[i]
        push!(neighbors, State(new_stream, Veichle(0, 0, state.veichle_velocity)))
    end

    return neighbors
end


function generate_random_pairs(max, n)
    generated_pairs = Set{Tuple{Int, Int}}()
    
    # Initialize an empty array to store pairs
    pairs = []
    
    # Generate pairs until we have n unique pairs
    while length(pairs) < n
        # Generate a random pair of numbers
        pair = (rand(1:max), rand(1:max))
        
        # Ensure the pair is not already generated
        if pair ∉ generated_pairs
            push!(pairs, pair)
            push!(generated_pairs, pair)
        end
    end
    
    return pairs
end
