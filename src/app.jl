using Distributions
using Dash
using PlotlyJS, DataFrames

include("models.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")
include("algorithms/tabu_search.jl")

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

app = dash()

# Initial values
initial_stream_size = 10
initial_iterations = 100

# Used algorithms
algorithms = [
    Dict("label" => "Hill Climbing", "value" => "hill_climbing"),
    Dict("label" => "Simulated Annealing", "value" => "simulated_annealing"),
    Dict("label" => "Genetic Algorithm", "value" => "genetic_algorithm"),
    Dict("label" => "Tabu Search", "value" => "tabu_search"),
]


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
            dcc_dropdown(id="algorithm", options=algorithms, value = ""),
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
        style=Dict(
            "display"=>"none",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
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
    Output("bind-tuning", "style"),
    Output("bind-tuning", "children"),
    Input("algorithm", "value")
) do selected_algorithm
    if selected_algorithm == "hill_climbing" 
        return Dict(
            "display"=>"none",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "borderRadius"=>"10px",
        ), []
    elseif selected_algorithm == "simulated_annealing"
        return Dict(
            "display"=>"none",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "borderRadius"=>"10px",
        ), []
    elseif selected_algorithm == "genetic_algorithm"
        return Dict(
            "display"=>"none",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "borderRadius"=>"10px",
        ), []
    elseif selected_algorithm == "tabu_search"
        return Dict(
            "display"=>"block",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "margin"=>"20px",
            "borderRadius"=>"10px",
        ), [
            html_h2(
                "Bind Tuning",
                style=Dict(
                    "margin"=>"0",
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )   
            ),
            html_label(
                "Max Tabu Size: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_slider(
                id="tabu-size",
                min = 10,
                max = 100,
                marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:9]),
                value = 10,
            ),
            html_label(
                "Number of neighbors: ",
                style=Dict(
                    "color"=>"#FFFFFF",
                    "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                )    
            ),
            dcc_slider(
                id="n-neighbors",
                min = 10,
                max = 50,
                marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:5]),
                value = 10,
            )
        ]
    else 
        return Dict(
            "display"=>"none",
            "backgroundColor"=>"#51829B",
            "padding"=>"20px",
            "borderRadius"=>"10px",
        ), []
    end
end

callback!(
    app, 
    Output("graph", "children"),
    Input("algorithm", "value"),
    Input("map_size", "value"),
    Input("velocity", "value"),
) do selected_algorithm, map_size, velocity
    if selected_algorithm == ""
        return html_p(
            "Select an algorithm"
        )
    end

    xs=[]
    ys=[]
    for n in [100,500,1000,2500,5000,10000]
        state = run_algorithm(selected_algorithm, n, map_size, velocity)
        push!(xs, n)
        push!(ys, state.total_time)
    end

    trace = scatter(x=xs, y=ys, mode="lines+markers", name="Time elapsed")

    return dcc_graph(figure=plot([trace], Layout(title="Time elapsed")))
end

function run_algorithm(algorithm, num_packages, map_size, velocity)
    packages_stream = generate_package_stream(num_packages, map_size)
    initial_state = State(packages_stream, Veichle(0, 0, velocity))

    if algorithm == "hill_climbing"
        return "Hill Climbing"
    elseif algorithm == "simulated_annealing"
        return "Simulated Annealing"
    elseif algorithm == "genetic_algorithm"
        return "Genetic Algorithm"
    elseif algorithm == "tabu_search"
        return tabu(initial_state, 1000, 10, 10)
    end
end

run_server(app, "0.0.0.0", 8000, debug=true)