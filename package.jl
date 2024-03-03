using Distributions
import DataFrames

mutable struct Package
    type::String
    coordinates_x::Float64
    coordinates_y::Float64

    breaking_chance::Union{Float64, Nothing}
    breaking_cost::Union{Float64, Nothing}
    delivery_time::Union{Float64, Nothing}

    function Package(type::String, coordinates_x::Float64, coordinates_y::Float64)
        if type == "fragile"
            breaking_chance = rand(Uniform(0.0001, 0.01))
            breaking_cost = rand(Uniform(3, 10))
            new(type, coordinates_x, coordinates_y, breaking_chance, breaking_cost, nothing)
        elseif type == "urgent"
            delivery_time = rand(Uniform(100, 240))
            new(type, coordinates_x, coordinates_y, nothing, nothing, delivery_time)
        else
            new(type, coordinates_x, coordinates_y, nothing, nothing, nothing)
        end
    end
end

function generate_package_stream(num_packages, map_size)
    types = ["fragile", "normal", "urgent"]
    return [Package(
                rand(types),
                rand(Uniform(0, map_size)),
                rand(Uniform(0, map_size)),
            ) for _ in 1:num_packages]
end

# Example: Generate a stream of 15 packages in a map of size 60x60
num_packages = 15
map_size = 60
package_stream = generate_package_stream(num_packages, map_size)
df = DataFrames.DataFrame(
    [(i, package.type, package.coordinates_x, package.coordinates_y, package.breaking_chance, package.breaking_cost, package.delivery_time) for (i, package) in enumerate(package_stream)], 
    [:Package, :Type, :CoordinatesX, :CoordinatesY, :Breaking_Chance, :Breaking_Cost, :Delivery_Time]
)