#!/bin/bash

# Define your base path
export CONDA_BASE_PATH="$HOME/repos"

# Function to check if the current directory is under the base directory
function is_inside_base_path() {
    local current_dir="$(pwd)"
    if [[ "${current_dir#"$CONDA_BASE_PATH"}" != "$current_dir" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to find environment.yml and activate conda environment
function activate_conda_environment() {
    if is_inside_base_path; then
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
    else
        echo "Not inside the base directory: $CONDA_BASE_PATH"
    fi
}

activate_conda_environment

