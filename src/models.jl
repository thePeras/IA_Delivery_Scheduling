module Models

using Distributions

mutable struct Veichle
    coordinates_x::Float64
    coordinates_y::Float64
    velocity::Int64
end

struct Package
    id::Int
    type::String
    coordinates_x::Float64
    coordinates_y::Float64

    breaking_chance::Union{Float64, Nothing}
    breaking_cost::Union{Float64, Nothing}
    delivery_time::Union{Float64, Nothing}

    function Package(id::Int, type::String, coordinates_x::Float64, coordinates_y::Float64)
        if type == "fragile"
            breaking_chance = rand(Uniform(0.0001, 0.01))
            breaking_cost = rand(Uniform(3, 10))
            new(id, type, coordinates_x, coordinates_y, breaking_chance, breaking_cost, nothing)
        elseif type == "urgent"
            delivery_time = rand(Uniform(100, 240))
            new(id, type, coordinates_x, coordinates_y, nothing, nothing, delivery_time)
        else
            new(id, type, coordinates_x, coordinates_y, nothing, nothing, nothing)
        end
    end
end

mutable struct State
    veichle::Veichle
    remaining_packages::Dict{Int, Package}
    delivered_packages::Dict{Int, Package}
    broken_packages::Dict{Int, Package}
    late_packages::Int

    total_distance::Float64
    total_time::Float64

    broken_package_cost::Float64

    function State(remaining_packages::Dict{Int64, Package}, velocity::Int64)
        new(Veichle(0, 0, velocity), remaining_packages, Dict{Int, Package}(), Dict{Int, Package}(), 0, 0, 0, 0)
    end
end

# (State, Package) -> Bool
function next_state!(state::State, selected_package::Package)
    # If next_package is fragile, calculate the probability of breaking
    package_distance = sqrt((state.veichle.coordinates_x - selected_package.coordinates_x)^2 + (state.veichle.coordinates_y - selected_package.coordinates_y)^2)
    state.total_distance += package_distance
    state.total_time += (package_distance * 60) / state.veichle.velocity
    state.veichle.coordinates_x = selected_package.coordinates_x
    state.veichle.coordinates_y = selected_package.coordinates_y

    if selected_package.type == "fragile"
        p_broken = 1 - ((1 - selected_package.breaking_chance) ^ state.total_distance)
        if rand(Uniform(0, 1)) < p_broken
            state.broken_packages[selected_package.id] = selected_package
            delete!(state.remaining_packages, selected_package.id)
            state.broken_package_cost += selected_package.breaking_cost
            return false
        end
    end

    state.delivered_packages[selected_package.id] = selected_package
    delete!(state.remaining_packages, selected_package.id)
    return true
end

export State, Package, next_state!

end