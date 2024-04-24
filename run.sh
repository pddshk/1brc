#!/usr/bin/env bash


# Function to install Julia on UNIX
install_julia_unix() {
    echo "Installing Julia on Unix..."
    curl -fsSL https://install.julialang.org | sh
}


# Check the operating system and install Julia accordingly
case "$(uname -s)" in
    Linux*)
        install_julia_unix
        ;;
    Darwin*)
        install_julia_unix
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac

# Check if data.txt exists
if [ ! -f "data.txt" ]; then
    echo "data.txt not found. Getting data..."
    ./get_data.sh
else
    echo "data.txt already exists."
fi
# Define the Julia script filename (default to naive.jl if no argument is provided)
JULIA_SCRIPT=${1:-"naive.jl"}

# Run the Julia script
julia "$JULIA_SCRIPT"
