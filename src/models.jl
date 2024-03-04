module Models

using Distributions

mutable struct Veichle
    coordinates_x::Float64
    coordinates_y::Float64
end

mutable struct State
    veichle::Veichle
    remaining_packages::Dict{Int, Package}
    delivered_packages::Dict{Int, Package}
    broken_packages::Dict{Int, Package}

    function State(remaining_packages::Dict{Int, Package})
        new(Veichle(0, 0), remaining_packages, Dict{Int, Package}(), Dict{Int, Package}())
    end
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

# (State, Package) -> Bool
function next_state!(state::State, next_package::Package)
    # If next_package is fragile, calculate the probability of breaking
    package_distance = sqrt((state.veichle.coordinates_x - next_package.coordinates_x)^2 + (state.veichle.coordinates_y - next_package.coordinates_y)^2)
    state.total_distance += package_distance
    state.veichle.coordinates_x = next_package.coordinates_x
    state.veichle.coordinates_y = next_package.coordinates_y

    # remove package from remaining_packages

    if next_package.type == "fragile"
        p_broken = 1 - ((1 - next_package.breaking_chance) ^ distance_covered)
        if rand(Uniform(0, 1)) < p_broken
            state.broken_packages[next_package.id] = next_package
            delete!(state.remaining_packages, next_package.id)
            return false
        end
    end

    # Remove next_package from remaining_packages
    state.delivered_packages[next_package.id] = next_package
    delete!(state.remaining_packages, next_package.id)
    return true
end

export State, Package, next_state!

end