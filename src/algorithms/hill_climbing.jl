using .Models: State, Package, Veichle

#=
    Hill Climbing algorithm to solve the Delivery Schedule Optimization Problem.
    - state: Initial state of the problem
    - max_iterations: Maximum number of iterations to run the algorithm

    Returns the best state found by the Hill Climbing algorithm.
=#
function hill_climbing(state::State, max_iterations::Int64 = 100)
    current_iteration = 0
    current_state = state
    best_fitness = fitness(state)
    
    while current_iteration < max_iterations
        neighbor = get_neighbor(current_state)
        neighbor_fitness = fitness(neighbor)

        if neighbor_fitness > best_fitness
            best_fitness = neighbor_fitness
            current_state = neighbor
            current_iteration = 0; # Restart the counter
        end

        current_iteration += 1
    end
    return current_state
end

export hill_climbing
