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

# Function to find environment.yml, activate conda environment, and set the active directory
function activate_conda_environment() {
    if is_inside_base_path; then
        local current_dir="$(pwd)"

        while [[ "$current_dir" != "/" && "$current_dir" != "$CONDA_BASE_PATH" ]]; do
            if [[ -f "$current_dir/environment.yml" ]]; then
                local env_name=$(grep -oP '(?<=name: ).*' "$current_dir/environment.yml")

                if [[ "$env_name" != "" ]]; then
                    echo "Activating conda environment: $env_name"
                    conda activate "$env_name"
                    export CONDA_ACTIVE_DIR="$current_dir"
                else
                    echo "No environment name found in environment.yml"
                fi

                return
            fi

            current_dir="$(dirname "$current_dir")"
        done

        echo "No environment.yml file found in the current directory or its parents"
    else
        echo "Not inside the base directory: $CONDA_BASE_PATH"
    fi
}

# Function to deactivate conda environment if the active directory is no longer in the path
function deactivate_conda_environment() {
    if [[ -n "$CONDA_ACTIVE_DIR" ]] && [[ "${PWD#"$CONDA_ACTIVE_DIR"}" == "$PWD" ]]; then
        echo "Deactivating conda environment"
        conda deactivate
        unset CONDA_ACTIVE_DIR
    fi
}
activate_conda_environment
deactivate_conda_environment
