{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    hyprland.enable = true; #someone forgot to set this so desktop file is created
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  environment.systemPackages = with pkgs; [
    chromium
    p7zip # 7zip
    amfora # Fancy Terminal Browser For Gemini Protocol
    appimage-run # Needed For AppImage Support
    brave # Brave Browser
    brightnessctl # For Screen Brightness Control
    cliphist # Clipboard manager using rofi menu
    docker-compose # Allows Controlling Docker From A Single File
    duf # Utility For Viewing Disk Usage In Terminal
    eza # Beautiful ls Replacement
    ffmpeg # Terminal Video / Audio Editing
    file-roller # Archive Manager
    gedit # Simple Graphical Text Editor
    gimp # Great Photo Editor
    glxinfo #needed for inxi diag util
    htop # Simple Terminal Based System Monitor
    jq # Command-line JSON processor
    hyprpicker # Color Picker
    eog # For Image Viewing
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nixfmt-rfc-style # Nix Formatter
    nwg-displays #configure monitor configs via GUI
    onefetch #provides zsaneyos build info on current system
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    picard # For Changing Music Metadata & Getting Cover Art
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    rhythmbox
    ripgrep # Improved Grep
    socat # Needed For Screenshots
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    v4l-utils # Used For Things Like OBS Virtual Camera
    lazygit # Terminal based git gui
    wget # Tool For Fetching Files With Links
    expect # Tool for running shell script while expecting output
    ytmdl # Tool For Downloading Audio From YouTube
    # Webcam
    android-tools
    nodejs
    poetry
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        pandas
        requests
      ]))
    rocmPackages.rocminfo
    clinfo
    rocmPackages.clr.icd
    unstable.claude-code
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
    (pkgs.makeDesktopItem {
      name = "claude-desktop";
      desktopName = "Claude";
      exec = "claude-desktop %u";
      icon = "claude-desktop";
      comment = "Claude Desktop";
      categories = ["Office" "Utility"];
      mimeTypes = ["x-scheme-handler/claude"];
    })
    go-crx3
    nodePackages.node2nix
    lftp
    rsync
    php
    tmux
  ];
}
