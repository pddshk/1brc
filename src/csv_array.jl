using BenchmarkTools
using CSV


mutable struct Record
    min::Float32
    max::Float32
    sum::Float32
    avg::Float32
    count::Int
end

function process_data(filepath)
    stats = Dict{String, Record}()

    csv_reader = CSV.File(
        filepath;
        delim=';',
        header=["city", "temp"],
        ignoreemptyrows=true,
        skipto=3,
        limit=1_000,
        types=[String, Float32],
    )

    for (city::String, temp::Float32) in csv_reader
        if haskey(stats, city)
            city_stats = stats[city]
            city_stats.min = min(temp, city_stats.min)
            city_stats.max = max(temp, city_stats.max)
            city_stats.sum += temp
            city_stats.count += 1
        else
            stats[city] = Record(temp, temp, temp, 0, 1)
        end
    end
    for (_, city_stats) in stats
        city_stats.avg = city_stats.sum / city_stats.count
    end
    return stats
end

function print_stats(stats)
    for (city, city_stats) in stats
        println(
            city, ";", city_stats.min, ";", city_stats.max, ";", city_stats.avg
        )
    end
end

function main()
    filepath = isempty(ARGS) ? "weather_stations.csv" : ARGS[1]
    bres = @benchmark process_data($filepath)
    display(bres)
    return bres
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
