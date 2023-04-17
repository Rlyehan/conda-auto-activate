#!/bin/bash

# Check the current shell
current_shell="$(basename "$SHELL")"
config_file="${HOME}/.${current_shell}rc"

if [ "$current_shell" == "bash" ] || [ "$current_shell" == "zsh" ]; then
    # Check if the code exists in the config file
    if grep -q "conda_auto_env" "$config_file"; then
        echo "Uninstalling conda_auto_env from ${config_file}..."

        # Remove the lines related to conda_auto_env
        sed -i.bak '/# --- conda_auto_env ---/,/alias cd="cd_with_conda_environment"/d' "$config_file"

        # Remove the backup file created by sed
        rm "${config_file}.bak"

        echo "Successfully uninstalled conda_auto_env from ${config_file}."
    else
        echo "conda_auto_env not found in ${config_file}."
    fi
else
    echo "Unsupported shell: ${current_shell}. conda_auto_env supports bash and zsh only."
fi
