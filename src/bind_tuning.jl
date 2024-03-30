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
                    id="n_neighbors",
                    min = 10,
                    max = 50,
                    marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:5]),
                    value = 10,
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
                html_label(
                    "Initial Temperature: ",
                    style=Dict(
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )    
                ),
                dcc_slider(
                    id="initial_temperature",
                    min = -50,
                    max = 100,
                    marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:9]),
                    value = 100.0,
                ),
                html_label(
                    "Cooling Rate: ",
                    style=Dict(
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )    
                ),
                dcc_slider(
                    id="cooling_rate",
                    min = 0,
                    max = 1,
                    marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:5]),
                    value = 0.9,
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
                html_label(
                    "Number of Population: ",
                    style=Dict(
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )    
                ),
                dcc_slider(
                    id="n_population",
                    min = 10,
                    max = 150,
                    marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:9]),
                    value = 50,
                ),
                html_label(
                    "Max Generations: ",
                    style=Dict(
                        "color"=>"#FFFFFF",
                        "fontFamily"=>"Source Sans Pro, Arial, sans-serif",
                    )    
                ),
                dcc_slider(
                    id="max_generations",
                    min = 20,
                    max = 200,
                    marks = Dict([i => (i == 1 ? "Label $(i)" : "$(i)") for i = 1:8]),
                    value = 100,
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