#!/bin/bash

# Function to find environment.yml and activate conda environment
function activate_conda_environment() {
    local current_dir="$(pwd)"

    if [[ -f "$current_dir/environment.yml" ]]; then
        local env_name=$(grep -oP '(?<=name: ).*' "$current_dir/environment.yml")

        if [[ "$env_name" != "" ]]; then
            echo "Activating conda environment: $env_name"
            conda activate "$env_name"
        else
            echo "No environment name found in environment.yml"
        fi
    else
        echo "No environment.yml file found in the current directory"
    fi
}

activate_conda_environment
