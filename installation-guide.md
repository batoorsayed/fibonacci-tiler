# Installation Guide

This guide provides step-by-step instructions for manually installing.

## 1. Install Required Packages

First, install the necessary dependencies:

```bash
sudo apt update
sudo apt install devilspie2 xdotool wmctrl
```

## 2. Create Directories

Create the required directories:

```bash
mkdir -p ~/.config/devilspie2
mkdir -p ~/.local/share/fibonacci-layout
mkdir -p ~/.local/share/cinnamon/applets/fibonacci-layout@batoorsayed
mkdir -p ~/.config/autostart
mkdir -p ~/bin
```

## 3. Install Devilspie2 Script

Copy the `fibonacci-layout.lua` file to the Devilspie2 configuration directory:

```bash
cp fibonacci-layout.lua ~/.config/devilspie2/
```

## 4. Install Window Swapping Script

Copy the window swapping script to your bin directory and make it executable:

```bash
cp fibonacci-window-swap.sh ~/bin/
chmod +x ~/bin/fibonacci-window-swap.sh
```

## 5. Install Cinnamon Applet

Copy the applet files to the Cinnamon applets directory:

```bash
cp metadata.json ~/.local/share/cinnamon/applets/fibonacci-layout@batoorsayed/
cp applet.js ~/.local/share/cinnamon/applets/fibonacci-layout@batoorsayed/
```

## 6. Set Up Autostart

Copy the desktop file to the autostart directory:

```bash
cp fibonacci-layout.desktop ~/.config/autostart/
```

## 7. Set Up Keyboard Shortcuts

1. Open System Settings → Keyboard → Shortcuts → Custom Shortcuts
2. Click "Add custom shortcut"
3. Create the following shortcuts:
   - Name: "Move window to main area"
   - Command: `~/bin/fibonacci-window-swap.sh to-main`
   - Shortcut: Super+M
   - Name: "Move sub window up"
   - Command: `~/bin/fibonacci-window-swap.sh move-up`
   - Shortcut: Super+Shift+Up
   - Name: "Move sub window down"
   - Command: `~/bin/fibonacci-window-swap.sh move-down`
   - Shortcut: Super+Shift+Down

## 8. Enable the Applet

1. Log out and log back in (or restart Cinnamon with Alt+F2, then type 'r' and press Enter)
2. Right-click on the panel
3. Select "Add applets to the panel"
4. Find "Fibonacci Layout" and click "+" to add it

## 9. Start Using FibonacciTiler

1. Click the newly added applet in your panel
2. Toggle "Enable Fibonacci Layout" to start using it on the current workspace

## Troubleshooting

- If Devilspie2 doesn't start automatically, you can start it manually with: `devilspie2`
- To see debug output, run: `devilspie2 --debug`
- If the applet doesn't appear in the list, restart Cinnamon or log out and log back in

## Uninstallation

To uninstall FibonacciTiler:

```bash
rm -f ~/.config/devilspie2/fibonacci-layout.lua
rm -f ~/bin/fibonacci-window-swap.sh
rm -rf ~/.local/share/cinnamon/applets/fibonacci-layout@batoorsayed
rm -f ~/.config/autostart/fibonacci-layout.desktop
rm -rf ~/.local/share/fibonacci-layout
```
