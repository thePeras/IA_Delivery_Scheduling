module BindTuning

using Dash

function tabu_bt()
    return html_div(
        style=Dict(
            "border" => "1px solid #FFFFFF",
            "borderRadius" => "10px",
            "padding" => "20px",
            "width" => "20%",
            "color" => "#FFFFFF",
            "fontFamily" => "Source Sans Pro, Arial, sans-serif",
        ),
        children=[
            html_h2(
                "Tabu Search",
            ),
            html_div(
                children=[
                    html_label("Max Tabu Size: "),
                    dcc_input(
                        type="number",
                        id="tabu_size",
                        min=10,
                        max=100,
                        value=15,
                    ),
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Number of neighbors: ",
                    ),
                    dcc_input(
                        type="number",
                        id="n_neighbors",
                        min=10,
                        max=100,
                        value=30,
                    )
                ]
            )
        ],
    )
end


function simulated_annealing_bt()
    return html_div(
        style=Dict(
            "color" => "#FFFFFF",
            "fontFamily" => "Source Sans Pro, Arial, sans-serif",
            "border" => "1px solid #FFFFFF",
            "borderRadius" => "10px",
            "padding" => "20px",
            "width" => "20%",
        ),
        children=[
            html_h2(
                "Simulated Annealing",
            ),
            html_div(
                children=[
                    html_label(
                        "Initial Temperature: ",
                    ),
                    dcc_input(
                        type="number",
                        id="initial_temperature",
                        min=0,
                        max=500,
                        value=100,
                        step=0.5,
                    ),
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Cooling Rate: ",
                    ),
                    dcc_input(
                        type="number",
                        id="cooling_rate",
                        min=0,
                        max=1,
                        value=0.9,
                        step=0.1,
                    )
                ]
            )
        ],
    )
end


function genetic_algorithm_bt()
    return html_div(
        style=Dict(
            "color" => "#FFFFFF",
            "fontFamily" => "Source Sans Pro, Arial, sans-serif",
            "border" => "1px solid #FFFFFF",
            "borderRadius" => "10px",
            "padding" => "20px",
            "width" => "30%",
        ),
        children=[
            html_h2(
                "Genetic Algorithm",
            ),
            html_div(
                children=[
                    html_label(
                        "Number of Population: ",
                    ),
                    dcc_input(
                        type="number",
                        id="n_population",
                        min=10,
                        max=500,
                        value=150,
                    ),
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Elitism Population Size: ",
                    ),
                    dcc_input(
                        type="number",
                        id="elitism_population_size",
                        min=0,
                        max=500,
                        value=10,
                    ),
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Mutation Rate: ",
                    ),
                    dcc_input(
                        type="number",
                        id="mutation_rate",
                        min=0,
                        max=1.0,
                        value=0.2,
                        step=0.05,
                    )
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Selection Function: ",
                    ),
                    dcc_dropdown(
                        id="selection_function",
                        style=Dict(
                            "color" => "#000000",
                        ),
                        options=[
                            Dict("label" => "Tournament Selection", "value" => "tournament"),
                            Dict("label" => "Roulette Wheel Selection", "value" => "roulette_wheel"),
                            Dict("label" => "Rank-based Selection", "value" => "rank_based"),
                        ],
                        value="tournament",
                    )
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Crossover Function: ",
                        style=Dict(
                            "color" => "#FFFFFF",
                        )
                    ),
                    dcc_dropdown(
                        id="crossover_function",
                        style=Dict(
                            "color" => "#000000",
                        ),
                        options=[
                            Dict("label" => "One Point Crossover", "value" => "one_point"),
                            Dict("label" => "Multi Point Crossover", "value" => "multi_point"),
                            Dict("label" => "Uniform Crossover", "value" => "uniform"),
                        ],
                        value="one_point",
                    )
                ]
            ),
            html_div(
                children=[
                    html_label(
                        "Number of Crossover Points: ",
                        style=Dict(
                            "color" => "#FFFFFF",
                        )
                    ),
                    dcc_input(
                        type="number",
                        id="num_crossover_points",
                        min=0,
                        max=1000,
                        value=5,
                    )
                ]
            )]
    )
end

end