using Distributions
using Plots

include("utils.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")
include("algorithms/tabu_search.jl")

using .Models: State, Package, Veichle, Population

function graphPlot()
    num_packages = 100
    map_size = 60
    velocity = 60 # km⋅h⁻¹

    packages_stream = generate_package_stream(num_packages, map_size)
    
    algorithms = ["Hill Climbing", "Simulated Annealing", "Genetic Algorithm", "Tabu Search"]
    iterations_list = [100, 500, 1000, 2000]  
    results = Dict{String, Tuple{Vector{Float64}, Vector{Int}}}() 
    
    for algorithm in algorithms
        times = []
        max_iters_list = []

        for iterations in iterations_list
            println("Running $algorithm with $iterations iterations...")

            state::State = State(packages_stream, Veichle(0, 0, velocity))
            start_time = time_ns()

            if algorithm == "Hill Climbing"
                current_state = hill_climbing(state, iterations)
            elseif algorithm == "Simulated Annealing"
                current_state = simulated_annealing(state, iterations, 100.0, 0.95)
            elseif algorithm == "Genetic Algorithm"
                current_state = genetic_algorithm(state, 150, iterations, 10, 0.2)
            elseif algorithm == "Tabu Search"
                current_state = tabu(state, iterations)
            end

            end_time = time_ns()
            elapsed_time = (end_time - start_time) / 1.0e9  # Convert ns to seconds
            push!(times, current_state.total_time)
            push!(max_iters_list, iterations)
        end
        
        results["$algorithm"] = (times, max_iters_list)
    end

    # Plotting
    plot_title = "Comparison of Optimization Algorithms"
    plot(xlabel="Iterations", ylabel="Solution Time (s)", title=plot_title, legend=:topright, xticks=[100, 500, 1000, 2000])
    for (algorithm, data) in results
        times, iters = data
        plot!(iters, times, label=algorithm, marker=:circle, markersize=5, linewidth=2)
    end
    
    savefig("optimization_comparison.png")
end

graphPlot()
