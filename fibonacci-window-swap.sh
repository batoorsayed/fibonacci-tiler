#!/bin/bash
# fibonacci-window-swap.sh
# Path: ~/bin/fibonacci-window-swap.sh

# Get action from command line argument
ACTION=$1
if [ -z "$ACTION" ]; then
    echo "Usage: $0 [to-main|move-up|move-down]"
    exit 1
fi

# Get current workspace and focused window
CURRENT_WORKSPACE=$(xdotool get_desktop)
FOCUSED_WINDOW=$(xdotool getactivewindow)

# Check if layout is enabled for this workspace
ENABLED_FILE="$HOME/.local/share/fibonacci-layout/workspace_${CURRENT_WORKSPACE}_enabled"
if [ ! -f "$ENABLED_FILE" ]; then
    notify-send "Fibonacci Layout" "Layout is not enabled on this workspace"
    exit 0
fi

# Get list of windows on this workspace
WINDOW_LIST_FILE="$HOME/.local/share/fibonacci-layout/workspace_${CURRENT_WORKSPACE}_windows"
if [ ! -f "$WINDOW_LIST_FILE" ]; then
    notify-send "Fibonacci Layout" "No window list found"
    exit 1
fi

# Read window list into array
mapfile -t WINDOWS < "$WINDOW_LIST_FILE"

# Find position of focused window
POSITION=-1
for i in "${!WINDOWS[@]}"; do
    if [ "${WINDOWS[$i]}" = "$FOCUSED_WINDOW" ]; then
        POSITION=$i
        break
    fi
done

# Check if window was found
if [ $POSITION -eq -1 ]; then
    notify-send "Fibonacci Layout" "Window not found in layout"
    exit 1
fi

# Perform requested action
case "$ACTION" in
    "to-main")
        # If not already main window (position 0)
        if [ $POSITION -ne 0 ]; then
            # Swap with main window
            TEMP=${WINDOWS[0]}
            WINDOWS[0]=${WINDOWS[$POSITION]}
            WINDOWS[$POSITION]=$TEMP
            notify-send "Fibonacci Layout" "Window moved to main area"
        else
            notify-send "Fibonacci Layout" "Window is already in main area"
        fi
        ;;
    "move-up")
        # If not already at top of sub area (position 1)
        if [ $POSITION -gt 1 ]; then
            # Swap with window above
            TEMP=${WINDOWS[$POSITION-1]}
            WINDOWS[$POSITION-1]=${WINDOWS[$POSITION]}
            WINDOWS[$POSITION]=$TEMP
            notify-send "Fibonacci Layout" "Window moved up in stack"
        elif [ $POSITION -eq 1 ]; then
            notify-send "Fibonacci Layout" "Window is already at top of sub area"
        else
            notify-send "Fibonacci Layout" "Cannot move main window"
        fi
        ;;
    "move-down")
        # If not at bottom
        if [ $POSITION -lt $((${#WINDOWS[@]}-1)) ] && [ $POSITION -gt 0 ]; then
            # Swap with window below
            TEMP=${WINDOWS[$POSITION+1]}
            WINDOWS[$POSITION+1]=${WINDOWS[$POSITION]}
            WINDOWS[$POSITION]=$TEMP
            notify-send "Fibonacci Layout" "Window moved down in stack"
        elif [ $POSITION -eq $((${#WINDOWS[@]}-1)) ] && [ $POSITION -gt 0 ]; then
            notify-send "Fibonacci Layout" "Window is already at bottom of stack"
        else
            notify-send "Fibonacci Layout" "Cannot move main window"
        fi
        ;;
    *)
        notify-send "Fibonacci Layout" "Unknown action: $ACTION"
        exit 1
        ;;
esac

# Write updated window list
printf "%s\n" "${WINDOWS[@]}" > "$WINDOW_LIST_FILE"

# TODO: Find a less disruptive way to trigger devilspie2 layout refresh than wmctrl -ia loop

# Use wmctrl to trigger window focus events which will cause devilspie2 to re-run
for window in "${WINDOWS[@]}"; do
    wmctrl -ia "$window"
done

# Restore focus to original window
wmctrl -ia "$FOCUSED_WINDOW"

exit 0
