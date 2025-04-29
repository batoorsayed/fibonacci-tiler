const Applet = imports.ui.applet;
const St = imports.gi.St;
const GLib = imports.gi.GLib;
const Util = imports.misc.util;
const Lang = imports.lang;
const Main = imports.ui.main;
const PopupMenu = imports.ui.popupMenu;
const Gettext = imports.gettext;
const Gio = imports.gi.Gio;

// l10n support
Gettext.bindtextdomain("fibonacci-layout@batoorsayed", GLib.get_home_dir() + "/.local/share/locale");

function _(str) {
  return Gettext.dgettext("fibonacci-layout@batoorsayed", str);
}

class FibonacciLayoutApplet extends Applet.TextIconApplet {
    constructor(orientation, panel_height, instance_id) {
        super(orientation, panel_height, instance_id);
        
        this.set_applet_tooltip(_("Toggle Fibonacci Layout"));
        this._fibonacciIcon = "view-grid-symbolic";
        this._floatingIcon = "window-new-symbolic";
        
        this.enabled = false;
        this.currentWorkspace = global.screen.get_active_workspace_index();
        
        // Create directories if they don't exist
        this._ensureDirectoriesExist();
        
        // Check if layout is enabled for current workspace
        this._checkEnabled();
        
        // Update icon based on state
        this._updateIcon();
        
        // Watch for workspace changes
        this._workspaceSignal = global.screen.connect('workspace-switched', 
                                Lang.bind(this, this._onWorkspaceChanged));
        
        // Create applet menu
        this._initMenu();
    }
    
    _ensureDirectoriesExist() {
        // Create the necessary directories
        let baseDir = GLib.get_home_dir() + "/.local/share/fibonacci-layout";
        let dir = Gio.File.new_for_path(baseDir);
        if (!dir.query_exists(null)) {
            dir.make_directory_with_parents(null);
        }
    }
    
    _initMenu() {
        this.menuManager = new PopupMenu.PopupMenuManager(this);
        this.menu = new Applet.AppletPopupMenu(this, this.orientation);
        this.menuManager.addMenu(this.menu);
        
        // Add toggle switch
        this.toggleSwitch = new PopupMenu.PopupSwitchMenuItem(
            _("Enable Fibonacci Layout"), this.enabled);
        
        this.toggleSwitch.connect('toggled', Lang.bind(this, this._onToggled));
        this.menu.addMenuItem(this.toggleSwitch);
        
        // Add refresh option
        this.menu.addMenuItem(new PopupMenu.PopupSeparatorMenuItem());
        const refreshItem = new PopupMenu.PopupMenuItem(_("Refresh Layout"));
        refreshItem.connect('activate', Lang.bind(this, this._onRefresh));
        this.menu.addMenuItem(refreshItem);
    }
    
    _onToggled() {
        this.enabled = !this.enabled;
        this._updateEnabled();
        this._updateIcon();
    }
    
    _onRefresh() {
        if (this.enabled) {
            this._refreshLayout();
        }
    }
    
    _checkEnabled() {
        const workspace = global.screen.get_active_workspace_index();
        const homeDir = GLib.get_home_dir();
        const enabledFile = homeDir + "/.local/share/fibonacci-layout/workspace_" + workspace + "_enabled";
        
        // Check if file exists
        let fileExists = GLib.file_test(enabledFile, GLib.FileTest.EXISTS);
        this.enabled = fileExists;
        
        // Update toggle switch if menu exists
        if (this.toggleSwitch) {
            this.toggleSwitch.setToggleState(this.enabled);
        }
    }
    
    _updateEnabled() {
        const workspace = global.screen.get_active_workspace_index();
        const homeDir = GLib.get_home_dir();
        const enabledFile = homeDir + "/.local/share/fibonacci-layout/workspace_" + workspace + "_enabled";
        
        if (this.enabled) {
            // Create enabled file
            Util.spawnCommandLine("touch " + enabledFile);
            
            // Apply layout
            this._refreshLayout();
        } else {
            // Remove enabled file
            Util.spawnCommandLine("rm -f " + enabledFile);
        }
    }
    
    _refreshLayout() {
        // Trigger a refresh of the layout by activating all windows
        Util.spawnCommandLine("wmctrl -l | grep -v 'Desktop$' | awk '{print $1}' | xargs -I{} wmctrl -ia {}");
        //Util.spawnCommandLine("bash -c 'killall -SIGUSR1 devilspie2'");
    }
    
    _updateIcon() {
        this.set_applet_icon_symbolic_name(
            this.enabled ? this._fibonacciIcon : this._floatingIcon);
    }
    
    _onWorkspaceChanged() {
        this.currentWorkspace = global.screen.get_active_workspace_index();
        this._checkEnabled();
        this._updateIcon();
    }
    
    on_applet_clicked() {
        this.menu.toggle();
    }
    
    on_applet_removed_from_panel() {
        if (this._workspaceSignal) {
            global.screen.disconnect(this._workspaceSignal);
        }
    }
}

function main(metadata, orientation, panel_height, instance_id) {
    return new FibonacciLayoutApplet(orientation, panel_height, instance_id);
}
