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
    packages_stream::Array{Package, 1}

    total_distance::Float64
    total_time::Float64
    total_late_minutes::Float64
    
    broken_packages::Array{Package, 1}
    broken_packages_cost::Float64

    veichle_velocity::Int64

    function State(packages_stream::Array{Package, 1}, veichle::Veichle);
        total_distance = 0
        total_time = 0
        total_late_minutes = 0
        broken_packages = []
        broken_packages_cost = 0

        for package in packages_stream
            distance = sqrt((veichle.coordinates_x - package.coordinates_x)^2 + (veichle.coordinates_y - package.coordinates_y)^2)
            total_distance += distance
            total_time += (distance * 60) / veichle.velocity
            veichle.coordinates_x = package.coordinates_x
            veichle.coordinates_y = package.coordinates_y

            if package.type == "fragile"
                p_broken = 1 - ((1 - package.breaking_chance) ^ total_distance)
                if rand(Uniform(0, 1)) < p_broken
                    push!(broken_packages, package)
                    broken_packages_cost += package.breaking_cost
                end
            end

            if package.type == "urgent"
                late_minutes = total_time - package.delivery_time
                if late_minutes > 0
                    total_late_minutes += late_minutes
                end
            end
        end

        return new(packages_stream, total_distance, total_time, total_late_minutes, broken_packages, broken_packages_cost, veichle.velocity)
    end
end

export State, Package

end