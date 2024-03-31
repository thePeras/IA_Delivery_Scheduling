module BindTuning

    using Dash

    function tabu_bt() 
        return html_div(
            children=[
                html_h2(
                    "Tabu Search",
                    style=Dict(
                        "margin"=>"0",
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )   
                ),
                html_div(
                    children=[
                        html_label(
                            "Max Tabu Size: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="tabu_size",
                            min = 10,
                            max = 100,
                            value = 10,
                        ),
                    ]
                ),
                html_div(
                    children=[
                        html_label(
                            "Number of neighbors: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="n_neighbors",
                            min = 10,
                            max = 50,
                            value = 10,
                        )
                    ]
                )
            ],
            style=Dict(
                "border"=>"1px solid #FFFFFF",
                "borderRadius"=>"10px",
                "padding"=>"20px",
                "width"=>"20%",
            )
        )
    end

    
    function simulated_annealing_bt()
        return html_div(
            children=[
                html_h2(
                    "Simulated Annealing",
                    style=Dict(
                        "margin"=>"0",
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )   
                ),
                html_div(
                    children=[
                        html_label(
                            "Initial Temperature: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="initial_temperature",
                            min = 0,
                            max = 100,
                            value = 100,
                            step=0.5,
                        ),
                    ]
                ),
                html_div(
                    children=[
                        html_label(
                            "Cooling Rate: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="cooling_rate",
                            min = 0,
                            max = 1,
                            value = 0.9,
                            step=0.1,
                        )
                    ]
                )
            ],
            style=Dict(
                "border"=>"1px solid #FFFFFF",
                "borderRadius"=>"10px",
                "padding"=>"20px",
                "width"=>"20%",
            )
        )
    end
    

    function genetic_algorithm_bt()
        return html_div(
            children=[
                html_h2(
                    "Genetic Algorithm",
                    style=Dict(
                        "margin"=>"0",
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )   
                ),
                html_div(
                    children=[
                        html_label(
                            "Number of Population: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="n_population",
                            min = 10,
                            max = 150,
                            value = 50,
                        ),
                    ]
                ),
                html_div(
                    children=[
                        html_label(
                            "Elitism Population Size: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="elitism_population_size",
                            min = 0,
                            max = 50,
                            value = 20,
                        ),
                    ]
                ),
                html_div(
                    children=[
                        html_label(
                            "Mutation Rate: ",
                            style=Dict(
                                "color"=>"#FFFFFF",
                                "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                            )    
                        ),
                        dcc_input(
                            type="number",
                            id="mutation_rate",
                            min = 0,
                            max = 1.0,
                            value = 0.01,
                            step=0.01,
                        )
                    ]
                )
            ],
            style=Dict(
                "border"=>"1px solid #FFFFFF",
                "borderRadius"=>"10px",
                "padding"=>"20px",
                "width"=>"20%",
            )
        )
    end

end