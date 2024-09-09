#!/bin/bash

Redshift="$HOME/.config/hypr/shaders/redshift.glsl"
Vibrance="$HOME/.config/hypr/shaders/vibrance-custom.glsl"
STATE_FILE="/tmp/shader_state"

output_json() {
    local text=$1
    local class=$2
    local percentage=$3
    echo "{\"text\": \"$text\", \"class\": \"$class\", \"percentage\": $percentage}"
}

update_state() {
    echo "$1" > "$STATE_FILE"
}

get_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "off"
    fi
}

case $1 in
    r)
        hyprshade on "$Redshift"
        output_json "100" "redshift" 100
        update_state "redshift"
        ;;
    v)
        hyprshade on "$Vibrance"
        output_json "50" "vibrance" 50
        update_state "vibrance"
        ;;
    off)
        hyprshade off
        output_json "00" "default" 0
        update_state "off"
        ;;
    *)
        current_state=$(get_state)
        case $current_state in
            "redshift")
                output_json "100" "redshift" 100
                ;;
            "vibrance")
                output_json "50" "vibrance" 50
                ;;
            *)
                output_json "00" "default" 0
                ;;
        esac
        ;;
esac