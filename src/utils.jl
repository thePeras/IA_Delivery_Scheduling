
include("models.jl")
using .Models: State, Package, Veichle, Population

#=
    Generate a stream of packages with random positions and types
=#
function generate_package_stream(num_packages, map_size)
    types = ["fragile", "normal", "urgent"]
    return [Package(
                i,
                rand(types),
                rand(Uniform(0, map_size)),
                rand(Uniform(0, map_size)),
            ) for i in 1:num_packages]
end

#=
    Common fitness function among all the algorithms to evaluate a State based on the following costs:
        1. Distance Cost: C * distance
        2. Damage Cost: Z * n_breaked_packages // Calculated in the State constructor
        3. Urgente Cost: C * total_late_minutes
=#
function fitness(state::State)    
    C = 0.3
    distance_cost = C * state.total_distance
    urgent_cost = C * state.total_late_minutes
    return - (distance_cost + state.broken_packages_cost + urgent_cost)
end

#=
    Get a neighbor of the given state by swapping two random packages
=#
function get_neighbor(state::State)
    n = length(state.packages_stream)
    i, j = rand(1:n), rand(1:n)
    new_packages_stream = copy(state.packages_stream)
    new_packages_stream[i], new_packages_stream[j] = new_packages_stream[j], new_packages_stream[i]
    return State(new_packages_stream, Veichle(0, 0, state.veichle_velocity))
end