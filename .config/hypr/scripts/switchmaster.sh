#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
    exit 1
fi

# Function to execute all scripts with the given argument
execute_all_scripts() {
    local arg="$1"
    
    # Importing all theme switching scripts
    scripts=(
        "$HOME/.config/hypr/scripts/switch1.sh"
        "$HOME/.config/hypr/scripts/switch2.sh"
        "$HOME/.config/hypr/scripts/switch3.sh"
        "$HOME/.config/hypr/scripts/switch4.sh"
        "$HOME/.config/hypr/scripts/switch5.sh"
        "$HOME/.config/hypr/scripts/switch6.sh"
        "$HOME/.config/hypr/scripts/switch7.sh"
        
    )

    # Execute each script with the provided argument
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            echo "Executing $script $arg"
            bash "$script" "$arg"
        else
            echo "Warning: $script not found"
        fi
    done
}

# Argument
case "$1" in
    -d|--dracula)
        execute_all_scripts "-d"
        ;;
    -g|--gruv)
        execute_all_scripts "-g"
        ;;
    -n|--nord)
        execute_all_scripts "-n"
        ;;
    -e|--everforest)
        execute_all_scripts "-e"
        ;;
    -b|--everblush)
        execute_all_scripts "-b"
        ;;
    *)
        echo "Invalid argument. Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord] [-e|--everforest] [-b|--everblush]"
        exit 1
        ;;
esac

echo "All theme changes have been applied."

