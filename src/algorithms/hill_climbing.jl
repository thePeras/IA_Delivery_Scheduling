using .Models: State, Package, Veichle, next_state!

function fitness(state::State)
    #=
        1. Distance Cost: C * distance
        2. Damage Cost: Z * n_breaked_packages
        3. Urgente Cost: C * late_minutes
    =#
    
    C = 0.3
    distance_cost = C * state.total_distance
    urgent_cost = C * state.late_packages
    return distance_cost + state.broken_package_cost + urgent_cost
end

function hill_climbing(state::State)
    current_state = deepcopy(state)
    while current_state.remaining_packages != Dict{Int, Package}()
        next_states = []
        for package in values(current_state.remaining_packages)
            next_state = deepcopy(current_state)
            next_state!(next_state, package)
            push!(next_states, next_state)
        end

        next_states_fitness = [fitness(state) for state in next_states]
        best_next_state = next_states[argmin(next_states_fitness)]
        current_state = best_next_state
    end
    return current_state
end

export hill_climbing
