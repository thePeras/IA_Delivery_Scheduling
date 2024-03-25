using .Models: State, Package, Veichle

function simulated_annealing(initial_state::State; max_iterations=5000, initial_temperature=100.0, cooling_rate=0.95)
    current_state = initial_state
    current_temperature = initial_temperature

    best_state = deepcopy(current_state)
    while current_temperature > 0.1
        for _ in 1:max_iterations
            next_state = get_neighbor(current_state)

            new_cost = fitness(next_state)
            old_cost = fitness(current_state)

            delta_energy = new_cost - old_cost
            if delta_energy < 0 || rand() < exp(-delta_energy / current_temperature)
                current_state = next_state
                if new_cost > fitness(best_state)
                    best_state = deepcopy(current_state)
                end
            end
        end
        current_temperature *= cooling_rate
    end

    return best_state
end
