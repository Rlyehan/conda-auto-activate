#!/bin/bash

conda_auto_env() {
  if [ "\$0" = "\${BASH_SOURCE[0]}" ] || [ "\$0" = "\${(%):-%x}" ]; then
    return 0
  fi

# Define your base path
CONDA_BASE_PATH="$HOME/Developer/python"

# Check the current shell
current_shell="$(basename "$SHELL")"

# Check the operating system
current_os="$(uname)"

# Check for macOS and zsh
if [ "$current_os" != "Darwin" ] || [ "$current_shell" != "zsh" ]; then
    echo "Error: conda_auto_env requires macOS and zsh."
    exit 1
fi

config_file="${HOME}/.${current_shell}rc"

# Check if the code has already been added to the config file
if ! grep -q "conda_auto_env" "$config_file"; then
    # Add the code to the configuration file
    echo "Installing conda_auto_env to ${config_file}..."

    cat <<'EOT' >> "$config_file"
# --- conda_auto_env ---
export CONDA_BASE_PATH="$CONDA_BASE_PATH"

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
                local env_name=$(sed -n 's/^name: //p' "$current_dir/environment.yml")

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

# Function to wrap 'cd' command and call deactivate_conda_environment and activate_conda_environment
function cd_with_conda_environment() {
    builtin cd "$@" && deactivate_conda_environment && activate_conda_environment
}

# Alias 'cd' to the new function
alias cd="cd_with_conda_environment"
EOT
    echo "Successfully installed conda_auto_env to ${config_file}."
else
    echo "conda_auto_env is already installed in ${config_file}."
fi
}
conda_auto_env
