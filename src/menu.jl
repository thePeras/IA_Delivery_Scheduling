module Menu

using TerminalMenus

function choose_algorithm()
    algorithms = ["Hill Climbing", "Simulated Annealing", "Tabu Search", "Genetic Algorithm"]
    menu = RadioMenu(algorithms)
    choice = request(menu)
    return algorithms[choice]
end

function choose_iterations()
    iterations = [500, 1000, 10000]
    menu = RadioMenu(string.(iterations))
    choice = request(menu)
    return iterations[choice]
end

function choose_menu()
    algorithm = choose_algorithm()
    iterations = choose_iterations()

    return algorithm, iterations
end

export choose_menu
end