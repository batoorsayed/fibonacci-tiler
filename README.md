# fibonacci-tiler

A lightweight Fibonacci window layout system for Linux Mint Cinnamon (thats what I intended to use) that maintains full compatibility with the existing desktop environment.

## Core Components

- **Devilspie2**: A lightweight window matching utility that monitors windows as they're created and applies rules to them.
- **Cinnamon Panel Applet**: A custom applet that adds a toggle switch in your panel to enable/disable the Fibonacci layout per workspace.
- **Window Swapping Utility**: A bash script that allows windows to be rearranged within the layout using keyboard shortcuts.
- **Configuration Files**: Simple text files that track window positions and layout states for each workspace.

## Requirements

- Devilspie2
- xdotool
- wmctrl

## Functionality

### Layout Behavior

- **Main/Sub Zone Division**: The screen is divided into a main zone (approximately 65% of screen width) and a sub zone for secondary windows.
- **Fibonacci Pattern**: Windows in the sub zone are arranged in decreasing sizes following a Fibonacci-like pattern.
- **Per-Workspace Control**: Layout can be enabled/disabled individually for each workspace.
- **Event-Driven**: The system only runs when window events occur (opening, closing, etc.), minimizing resource usage.

### User Interface

- **Panel Toggle**: The custom applet allows you to easily toggle the layout with a single click.
- **Keyboard Shortcuts**:
  - `Super+M`: Move focused window to main zone
  - `Super+Shift+Up`: Move sub window up in stack
  - `Super+Shift+Down`: Move sub window down in stack

### Visual Feedback

Small notifications inform you of layout changes or when operations can't be performed.

### Technical Implementation

- **Window Tracking**: Each workspace maintains a list of window IDs in the order they should appear in the layout.
- **State Storage**: Simple text files in `~/.local/share/fibonacci-layout/` track whether layout is enabled for each workspace.
- **Minimal Resource Usage**: No continuous background processes; scripts only run when window events occur.
- **Non-Intrusive**: When disabled, windows behave exactly as they would in vanilla Cinnamon.

## Installation & Setup

The system is installed through several components:

- Devilspie2, xdotool, wmctrl (package manager)
- Custom Lua scripts placed in `~/.config/devilspie2/`
- Cinnamon applet installed in `~/.local/share/cinnamon/applets/`
- Window swapping script placed in `~/bin/`
- Autostart entry to launch Devilspie2 at login

## Customization Options

The implementation includes several parameters that can be easily adjusted:

- **Main/Sub Ratio**: Change the proportion of screen allocated to main vs. sub zones
- **Window Margins**: Adjust the space between windows and screen edges
- **Gaps**: Modify the spacing between windows in the sub zone
- **Golden Ratio Factor**: Tune the Fibonacci sequence ratio for sub window sizing

## TODO

### Future Improvements

- Workspace profiles for different layout configurations
- Application-specific layouts
- Improved visual feedback
- Additional layout patterns

### Known Issues

- TODO: Make MAIN_RATIO, MARGIN, GAP configurable
- TODO: Find reliable way to get the geometry of the *monitor* containing the window
- TODO: Handle minimized/restored windows more gracefully (see proposed_minimization_handling)
- TODO: Only write window list file if changes occurred (added/removed window)
- TODO: Find a less disruptive way to trigger devilspie2 layout refresh than wmctrl -ia loop
- TODO: Implement logging for debugging purposes

### License

MIT License - see the LICENSE file for details.

### Acknowledgments

The **Devilspie2** project for window manipulation capabilities

## Contributing

Go right on ahead!
