using .Models: State, Package, Veichle

# Should it be called hill_descend ^.^?
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

#=
    1. Select two random package
    2. Swap the packages
=#
function get_neighbor(state::State)
    n = length(state.packages_stream)
    i, j = rand(1:n), rand(1:n)
    new_packages_stream = copy(state.packages_stream)
    new_packages_stream[i], new_packages_stream[j] = new_packages_stream[j], new_packages_stream[i]
    return State(new_packages_stream, Veichle(0, 0, state.veichle_velocity))
end

export hill_climbing
