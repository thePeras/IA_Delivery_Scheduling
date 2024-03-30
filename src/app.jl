using Distributions
using Dash
using PlotlyJS, DataFrames
using JSON3

include("models.jl")
include("bind_tuning.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")
include("algorithms/tabu_search.jl")

using .BindTuning: tabu_bt, simulated_annealing_bt, genetic_algorithm_bt

using .Models: State, Package, Veichle, Population

function generate_package_stream(num_packages, map_size)
    types = ["fragile", "normal", "urgent"]
    return [Package(
                i,
                rand(types),
                rand(Uniform(0, map_size)),
                rand(Uniform(0, map_size)),
            ) for i in 1:num_packages]
end

function fitness(state::State)
    #=
        1. Distance Cost: C * distance
        2. Damage Cost: Z * n_breaked_packages // Calculated in the State constructor
        3. Urgente Cost: C * total_late_minutes
    =#
    
    C = 0.3
    distance_cost = C * state.total_distance
    urgent_cost = C * state.total_late_minutes
    return - (distance_cost + state.broken_packages_cost + urgent_cost)
end

# ====================================
#             Variables
# global num_packages = 1000
# global map_size = 60
# global velocity = 60
# global tabu_size = 10
# global n_neighbors = 10
# global initial_temperature = 100.0 
# global cooling_rate = 0.95
# global n_population = 50
# global max_generations = 100 

# global packages_stream = generate_package_stream(num_packages, map_size)
# global initial_state = State(packages_stream, Veichle(0, 0, velocity))

# global current_index = 1

# global xs = [100,500,1000,2500,5000,10000]

# global tabu_search_y = []
# global simulated_annealing_y = []
# global hill_climbing_y = []
# global genetic_algorithm_y = []
# ====================================

app = dash()

app.layout = html_div() do
    html_h1(
        "Artificial Intelligence - Delivery Schedule Optimization Problem",
        style = Dict(
            "color"=>"#F6995C",
            "display"=>"flex",
            "justifyContent"=>"center",
            "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
        )
    ), 
    html_div(
        children=[
            html_label(
                "Map Size: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_input(
                id="map_size",
                type="number",
                min = 20,
                max = 200,
                value = 60,
            ),
            html_label(
                "Velocity: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_input(
                id="velocity",
                type="number",
                min = 20,
                max = 200,
                value = 60,
            ),
            html_label(
                "Number of Packages: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_input(
                id="num_packages",
                type="number",
                min = 100,
                max = 5000,
                value = 1000,
            ),
            html_label(
                "Number of Iterations: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_input(
                id="num_iterations",
                type="number",
                min = 500,
                max = 10000,
                value = 1000,
            ),
        ],
        style=Dict(
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "margin"=>"20px",
            "borderRadius"=>"10px",
        )
    ),
    html_div(
        id="bind-tuning",
        children=[
            html_h2(
                "Bind Tuning",
                style=Dict(
                    "margin"=>"0",
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )   
            ),
            html_div(
                children=[
                    tabu_bt(),
                    simulated_annealing_bt(),
                    genetic_algorithm_bt(),
                ],
                style=Dict(
                    "display"=>"flex",
                    "alignItems"=>"center",
                    "justifyContent"=>"center",
                    "gap"=>"2em",
                )
            )
        ],
        style=Dict(
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "margin"=>"20px",
            "borderRadius"=>"10px",
        )
    ),
    html_div(
        id="graph",
        style=Dict(
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "margin"=>"20px",
            "borderRadius"=>"10px",
        )
    )
end

callback!(
    app,
    Output("graph", "children"),
    Input("num_packages", "value"),
    Input("map_size", "value"),
    Input("velocity", "value"),
    Input("num_iterations", "value"),
    Input("tabu_size", "value"),
    Input("n_neighbors", "value"),
    Input("initial_temperature", "value"),
    Input("cooling_rate", "value"),
    Input("elitism_population_size", "value"),
    Input("mutation_rate", "value"),
    Input("n_population", "value")
) do num_packages, map_size, velocity, num_iterations, tabu_size, n_neighbors, initial_temperature, cooling_rate, elitism_population_size, mutation_rate, n_population
    if (isnothing(num_packages) || isnothing(map_size) || isnothing(velocity) || isnothing(num_iterations) || isnothing(tabu_size) || isnothing(n_neighbors) || isnothing(initial_temperature) || isnothing(elitism_population_size) || isnothing(mutation_rate) || isnothing(cooling_rate) || isnothing(n_population))
        return ""
    end

    packages_stream = generate_package_stream(num_packages, map_size)
    initial_state = State(packages_stream, Veichle(0, 0, velocity))

    tabu_data = tabu(initial_state, Int64(num_iterations), Int64(tabu_size), Int64(n_neighbors))
    hill_climbing_data = hill_climbing(initial_state, Int64(num_iterations))
    simulated_annealing_data = simulated_annealing(initial_state, Int64(num_iterations), Float64(initial_temperature), Float64(cooling_rate))
    genetic_algorithm_data = genetic_algorithm(initial_state, Int64(n_population), Int64(num_iterations), Int64(elitism_population_size), Float64(mutation_rate))

    return dcc_graph(
        figure=(
            data=[
                (x = ["Tabu Search", "Hill Climbing", "Simulated Annealing", "Genetic Algorithm"], y = [tabu_data.total_distance, hill_climbing_data.total_distance, simulated_annealing_data.total_distance, genetic_algorithm_data.total_distance], type="bar", name="Total Distance"),
                (x = ["Tabu Search", "Hill Climbing", "Simulated Annealing", "Genetic Algorithm"], y = [length(tabu_data.broken_packages), length(hill_climbing_data.broken_packages), length(simulated_annealing_data.broken_packages), length(genetic_algorithm_data.broken_packages)], type="bar", name="Broken Packages"),
                (x = ["Tabu Search", "Hill Climbing", "Simulated Annealing", "Genetic Algorithm"], y = [tabu_data.total_time, hill_climbing_data.total_time, simulated_annealing_data.total_time, genetic_algorithm_data.total_time], type="bar", name="Total Time"),
            ],
            layout = (title = "Algorithms Comparison", barmode="group")
        )
    )
end

run_server(app, "0.0.0.0", 8000, debug=true)