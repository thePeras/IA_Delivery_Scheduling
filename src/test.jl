# using Distributions
# using Dash
# using PlotlyJS

# include("models.jl")
# include("algorithms/tabu_search.jl")

# using .Models: State, Package, Veichle, Population

# function generate_package_stream(num_packages, map_size)
#     types = ["fragile", "normal", "urgent"]
#     return [Package(
#                 i,
#                 rand(types),
#                 rand(Uniform(0, map_size)),
#                 rand(Uniform(0, map_size)),
#             ) for i in 1:num_packages]
# end

# function fitness(state::State)
#     #=
#         1. Distance Cost: C * distance
#         2. Damage Cost: Z * n_breaked_packages // Calculated in the State constructor
#         3. Urgente Cost: C * total_late_minutes
#     =#
    
#     C = 0.3
#     distance_cost = C * state.total_distance
#     urgent_cost = C * state.total_late_minutes
#     return - (distance_cost + state.broken_packages_cost + urgent_cost)
# end

# app = dash()

# # Define initial values
# initial_stream_size = 10
# initial_iterations = 100

# # Define layout
# app.layout = html_div() do
#     dcc_dropdown(
#         id="algorithm-dropdown",
#         options=[
#             Dict("label" => "Tabu Search", "value" => "tabu_search"),
#         ],
#         value="tabu_search"
#     ),

#     dcc_input(
#         id="iterations-input",
#         type="number",
#         value=initial_iterations
#     ),

#     dcc_graph(id="path-graph")
# end

# # Define callback to update the plot
# callback!(
#     app,
#     Output("path-graph", "figure"),
#     Input("algorithm-dropdown", "value"),
#     Input("iterations-input", "value")
# ) do algorithm, iterations

#     packages_stream = generate_package_stream(100, 60)
#     initial_state = State(packages_stream, Veichle(0, 0, 60))

#     state = tabu(initial_state, 1000, 10, 10)

#     traces = []

#     for pkg in state.packages_stream
#         push!(traces, scatter(x=pkg.coordinates_x, y=pkg.coordinates_y, mode="markers", name=pkg.id))
#     end

#     layout = Layout(title="Path Graph")

#     return plot(traces, layout)
# end

# run_server(app, "127.0.0.1", 8050, debug=true)
