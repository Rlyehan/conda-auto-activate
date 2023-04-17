# conda-auto-activate

This repository contains two shell scripts:

conda_auto_env: A utility to automatically activate and deactivate conda environments when navigating through directories containing an environment.yml file. It is designed to work on macOS with the zsh shell.
remove_conda_auto_env: A utility to uninstall the conda_auto_env script from your shell configuration file.
Prerequisites
macOS
zsh or bash shell
Conda
Installation
Save the conda_auto_env script to a directory of your choice.
Run the script with the command source /path/to/conda_auto_env.sh.
The script will install itself into your zsh configuration file (e.g., .zshrc).
Usage
Once installed, you can use the cd command as usual. When you navigate to a directory containing an environment.yml file, the script will automatically activate the corresponding conda environment. When you leave that directory, the environment will be deactivated.

Configuration
By default, the script sets the base path for conda environments to $HOME/Developer/python. To use a different base path, modify the CONDA_BASE_PATH variable in the script.

bash
Copy code
# Define your base path
CONDA_BASE_PATH="$HOME/Developer/python"
Limitations
The script assumes that your conda environment names are unique, and it doesn't check for duplicate environment names. If you have duplicate environment names, you might experience unexpected behavior.

Uninstall
To uninstall conda_auto_env, follow these steps:

Save the remove_conda_auto_env script to a directory of your choice.
Run the script with the command source /path/to/remove_conda_auto_env.sh.
The script will remove the relevant lines of code from your shell configuration file (e.g., .zshrc or .bashrc) and uninstall conda_auto_env.