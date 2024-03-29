using Dash

include("models.jl")
include("algorithms/hill_climbing.jl")
include("algorithms/simulated_annealing.jl")
include("algorithms/genetic_algorithm.jl")
include("algorithms/tabu_search.jl")

app = dash()

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
            html_div(
                children=[
                    dcc_dropdown(id="algorithm", options=algorithms, value = ""),
                    html_label("Map Size: "),
                    dcc_slider(
                        id="map_size",
                        min = 20,
                        max = 200,
                        marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
                        value = 60,
                    ),
                    html_label("Velocity: "),
                    dcc_slider(
                        id="velocity",
                        min = 20,
                        max = 200,
                        marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:6]),
                        value = 60,
                    ),
                ],
                style=Dict(
                    "width"=>"30%",
                    "backgroundColor"=>"#9BB0C1",
                    "padding"=>"20px",
                    "borderRadius"=>"10px",
                )
            ),
            html_div(id="graph")
        ],
        style=Dict(
            "display"=>"flex",
            "gap"=>"50px",
            "alignItems"=>"center",
            "padding"=>"20px",
        )
        
    )
end

callback!(
    app, 
    Output("graph", "children"),
    Input("algorithm", "value"),
    Input("map_size", "value"),
    Input("velocity", "value"),
) do selected_algorithm, map_size, velocity
    return html_p(
        "Selected algorithm: $(selected_algorithm)\nMap size: $(map_size)\nVelocity: $(velocity)"
    )


end

function run_algorithm(algorithm)
    num_packages = 100

    # for i in num_packages:500:10000


    if algorithm == "hill_climbing"
        return "Hill Climbing"
    elseif algorithm == "simulated_annealing"
        return "Simulated Annealing"
    elseif algorithm == "genetic_algorithm"
        return "Genetic Algorithm"
    elseif algorithm == "tabu_search"
        return "Tabu Search"
    end
end

run_server(app, "0.0.0.0", 8000, debug=true)