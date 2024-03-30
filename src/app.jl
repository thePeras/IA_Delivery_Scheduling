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
global num_packages = 1000
global map_size = 60
global velocity = 60
global tabu_size = 10
global n_neighbors = 10
global initial_temperature = 100.0 
global cooling_rate = 0.95
global n_population = 50
global max_generations = 100 

global packages_stream = generate_package_stream(num_packages, map_size)
global initial_state = State(packages_stream, Veichle(0, 0, velocity))

global current_index = 1

global xs = [100,500,1000,2500,5000,10000]

global tabu_search_y = []
global simulated_annealing_y = []
global hill_climbing_y = []
global genetic_algorithm_y = []
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
            # dcc_dropdown(id="algorithm", options=algorithms, value = ""),
            html_label(
                "Map Size: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_slider(
                id="map_size",
                min = 20,
                max = 200,
                marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
                value = 60,
            ),
            html_label(
                "Velocity: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_slider(
                id="velocity",
                min = 20,
                max = 200,
                marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
                value = 60,
            ),
            html_label(
                "Number of Packages: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_slider(
                id="num_packages",
                min = 500,
                max = 10000,
                marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
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
    dcc_interval(
        id="interval-component",
        interval=1*1000,
        n_intervals=0
    ),
    dcc_store(
        id="store",
        data=Dict(
            "num_packages" => 1000,
            "map_size" => 60,
            "velocity" => 60,
            "tabu_size" => 10,
            "n_neighbors" => 10,
            "initial_temperature" => 100.0 ,
            "cooling_rate" => 0.95,
            "n_population" => 50,
            "max_generations" => 100 ,
            
            "packages_stream" => generate_package_stream(num_packages, map_size),
            "initial_state" => State(packages_stream, Veichle(0, 0, velocity)),
            
            "current_index" => 1,
            
            "xs" => [100,500,1000,2500,5000,10000],
            
            "tabu_search_y" => [],
            "simulated_annealing_y" => [],
            "hill_climbing_y" => [],
            "genetic_algorithm_y" => [],
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

# callback!(
#     app,
#     Output("bind-tuning", "style"),
#     Input("num_packages", "value"),
#     Input("map_size", "value"),
#     Input("velocity", "value"),
# ) do num_packages, map_size, velocity

#     packages_stream = generate_package_stream(num_packages, map_size)
#     initial_state = State(packages_stream, Veichle(0, 0, velocity))

#     for x in xs
#         push!(tabu_search_y, tabu(initial_state, x, 10, 10).total_distance)
#         # push!(simulated_annealing_y, simulated_annealing(initial_state, x, 100, 0.95).total_distance)
#         push!(hill_climbing_y, hill_climbing(initial_state, x).total_distance)
#         push!(genetic_algorithm_y, genetic_algorithm(initial_state, 50, 100, 20, 0.01).total_distance)
#     end

#     return Dict(
#         "backgroundColor"=>"#51829B",
#         "padding"=>"20px",
#         "margin"=>"20px",
#         "borderRadius"=>"10px",
#     )
# end

callback!(
    app,
    Output("store", "data"),
    Input("num_packages", "value"),
    Input("map_size", "value"),
    Input("velocity", "value"),
    Input("tabu-size", "value"),
    Input("n_neighbors", "value"),
    Input("initial_temperature", "value"),
    Input("cooling_rate", "value"),
    Input("n_population", "value"),
    Input("max_generations", "value"),

) do html_num_packages, html_map_size, html_velocity, html_tabu_size, html_n_neighbors, html_initial_temperature, html_cooling_rate, html_n_population, html_max_generations
    # num_packages = html_num_packages
    # map_size = html_map_size
    # velocity = html_velocity
    # tabu_size = html_tabu_size
    # n_neighbors = html_n_neighbors
    # initial_temperature = html_initial_temperature
    # cooling_rate = html_cooling_rate
    # n_population = html_n_population
    # max_generations = html_max_generations
    
    # packages_stream = generate_package_stream(num_packages, map_size)
    # initial_state = State(packages_stream, Veichle(0, 0, velocity))
    
    # current_index = 1

    return Dict(
        "num_packages" => num_packages,
        "map_size" => map_size,
        "velocity" => velocity,
        "tabu_size" => tabu_size,
        "n_neighbors" => n_neighbors,
        "initial_temperature" => initial_temperature,
        "cooling_rate" => cooling_rate,
        "n_population" => n_population,
        "max_generations" => max_generations,
        
        "packages_stream" => packages_stream,
        "initial_state" => initial_state,
        
        "current_index" => current_index,
        
        "xs" => xs,
        
        "tabu_search_y" => tabu_search_y,
        "simulated_annealing_y" => simulated_annealing_y,
        "hill_climbing_y" => hill_climbing_y,
        "genetic_algorithm_y" => genetic_algorithm_y,
    )
end


callback!(
    app,
    Output("graph", "children"),
    Input("interval-component", "n_intervals"),
    Input("store", "data"),
) do n_intervals, data
    current_index = data.current_index
    xs = data.xs
    tabu_search_y = data.tabu_search_y
    # simulated_annealing_y = data.simulated_annealing_y
    hill_climbing_y = data.hill_climbing_y
    genetic_algorithm_y = data.genetic_algorithm_y
    initial_state = data.initial_state

    println("variables")
    println("_________________________________")
    println("current_index: ", current_index)
    println("xs: ", xs)
    println("tabu_search_y: ", tabu_search_y)
    println("hill_climbing_y: ", hill_climbing_y)
    println("genetic_algorithm_y: ", genetic_algorithm_y)
    # println("initial_state: ", initial_state)
    println("_________________________________")
    

    push!(tabu_search_y, tabu(initial_state, xs[current_index], 10, 10).total_distance)
    push!(hill_climbing_y, hill_climbing(initial_state, xs[current_index]).total_distance)
    push!(genetic_algorithm_y, genetic_algorithm(initial_state, 50, 100, 20, 0.01).total_distance)

    current_index += 1
    
    # Plot the graph with updated data
    tabu_trace = scatter(x=xs[1:current_index], y=tabu_search_y[1:current_index], mode="lines+markers", name="Tabu Search")
    hill_climbing_trace = scatter(x=xs[1:current_index], y=hill_climbing_y[1:current_index], mode="lines+markers", name="Hill Climbing")
    genetic_algorithm_trace = scatter(x=xs[1:current_index], y=genetic_algorithm_y[1:current_index], mode="lines+markers", name="Genetic Algorithm")

    return dcc_graph(figure=plot([tabu_trace, hill_climbing_trace, genetic_algorithm_trace], Layout(title="Total Distance")))
end

run_server(app, "0.0.0.0", 8000, debug=true)