{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
  };
  home.file."./.config/ghostty/config".text = ''

    #theme = Aura
    theme = Tomorrow Night Bright
    #theme = Aardvark Blue
    #theme = GruvboxDarkHard
    adjust-cell-height = 10%
    window-theme = dark
    window-height = 32
    window-width = 110
    background-opacity = 0.95
    background-blur-radius = 60
    selection-background = #2d3f76
    selection-foreground = #c8d3f5
    cursor-style = bar
    mouse-hide-while-typing = true

    # keybindings
    keybind = alt+s>r=reload_config
    keybind = alt+s>x=close_surface

    keybind = alt+s>n=new_window

    # tabs
    keybind = alt+s>c=new_tab
    keybind = alt+s>shift+l=next_tab
    keybind = alt+s>shift+h=previous_tab
    keybind = alt+s>comma=move_tab:-1
    keybind = alt+s>period=move_tab:1

    # quick tab switch
    keybind = alt+s>1=goto_tab:1
    keybind = alt+s>2=goto_tab:2
    keybind = alt+s>3=goto_tab:3
    keybind = alt+s>4=goto_tab:4
    keybind = alt+s>5=goto_tab:5
    keybind = alt+s>6=goto_tab:6
    keybind = alt+s>7=goto_tab:7
    keybind = alt+s>8=goto_tab:8
    keybind = alt+s>9=goto_tab:9

    # split
    keybind = alt+s>\=new_split:right
    keybind = alt+s>-=new_split:down

    keybind = alt+s>j=goto_split:bottom
    keybind = alt+s>k=goto_split:top
    keybind = alt+s>h=goto_split:left
    keybind = alt+s>l=goto_split:right

    keybind = alt+s>z=toggle_split_zoom

    keybind = alt+s>e=equalize_splits

    # Claude Code keybinding
    keybind = shift+enter=text:\x0a

    # other
    #copy-on-select = clipboard

    font-size = 12
    #font-family = JetBrainsMono Nerd Font Mono
    #font-family-bold = JetBrainsMono NFM Bold
    #font-family-bold-italic = JetBrainsMono NFM Bold Italic
    #font-family-italic = JetBrainsMono NFM Italic

    font-family = BerkeleyMono Nerd Font
    #font-family = Iosevka Nerd Font
    # font-family = SFMono Nerd Font

    title = "GhosTTY"

    wait-after-command = false
    shell-integration = detect
    window-save-state = always
    gtk-single-instance = true
    unfocused-split-opacity = 0.5
    quick-terminal-position = center
    shell-integration-features = cursor,sudo

    # SSH compatibility - use xterm-256color for better compatibility
    term = xterm-256color
    # Image support - Configure memory limit for Kitty graphics protocol
    # This allows terminals to display images using the Kitty graphics protocol
    # 320MB is the default, increase if you work with many large images
    image-storage-limit = 320971520

    # Drag and Drop Support
    # Ghostty supports drag and drop of files by default
    # When you drag a file from your file manager into Ghostty, the file path
    # is automatically inserted at the cursor position
    # 
    # For Claude Code image analysis:
    # 1. Drag image files directly into Ghostty terminal running Claude Code
    # 2. Use the screenshot keybindings to capture images for analysis:
    #    - SUPER+SHIFT+S: Capture region for Claude (claude-image-helper region)
    #    - SUPER+ALT+S: Capture full screen for Claude (claude-image-helper capture)
    #    - SUPER+CTRL+S: Capture window for Claude (claude-image-helper window)
    # 3. Use 'claude-image-helper last' to get the path of the last screenshot
    # 4. Use 'claude-image-helper list' to see all recent Claude screenshots
  '';
}
