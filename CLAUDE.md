# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Repository Overview

ZaneyOS is a custom NixOS configuration system that provides a fully featured
desktop environment centered around Hyprland (a tiling Wayland compositor). The
configuration is structured as a NixOS flake with modular components.

## Architecture

The configuration is organized into three main components:

1. **Profiles**: Hardware-specific configurations
   - `amd` - AMD GPU configuration
   - `nvidia` - NVIDIA GPU configuration
   - `nvidia-laptop` - NVIDIA Optimus/Prime configuration
   - `intel` - Intel GPU configuration
   - `vm` - Virtual machine configuration

2. **Hosts**: Machine-specific configurations
   - Each host has its own directory with:
     - `default.nix` - Main host configuration
     - `hardware.nix` - Hardware-specific configuration
     - `host-packages.nix` - Host-specific packages
     - `variables.nix` - User-configurable variables

3. **Modules**: Core system components
   - `core/` - Core system modules (boot, network, services, etc.)
   - `drivers/` - GPU and hardware drivers
   - `home/` - Home-manager configurations for user environment

## Key Features

- Hyprland Wayland desktop environment with extensive customization
- Multiple theme options via stylix
- Multiple animation styles for Hyprland
- Various waybar configuration options
- AI tools integration (nixified-ai, ollama, claude-code)
- Hardware-specific optimizations

## Common Commands

### System Rebuild

To rebuild the NixOS system after making changes:

```bash
# Using nix-helper (nh)
nh os switch --hostname <profile>  # alias: fr
j
# Direct flake rebuild
sudo nixos-rebuild switch --flake ~/zaneyos/#<profile>
```

### Update System

To update packages and rebuild:

```bash
# Using nix-helper
nh os switch --hostname <profile> --update  # alias: fu

# Direct flake update
nix flake update ~/zaneyos
sudo nixos-rebuild switch --flake ~/zaneyos/#<profile>
```

### Garbage Collection

To clean up old generations:

```bash
# Using alias
ncg

# Full command
nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot
```

## Configuration Tips

### Adding New Packages

System-wide packages should be added to:

- `modules/core/packages.nix`

Host-specific packages should be added to:

- `hosts/<hostname>/host-packages.nix`

### Modifying User Variables

Most user-configurable options are in:

- `hosts/<hostname>/variables.nix`

This includes:

- Default applications (browser, terminal)
- Keyboard layout
- Theme/wallpaper selection
- Waybar style
- Animation style
- Feature toggles

### Hardware Configuration

Hardware-specific settings are in:

- `hosts/<hostname>/hardware.nix`

Driver configurations are in:

- `modules/drivers/`

### Claude Code Configuration

Claude Code is configured with:

- Co-authorship disabled
- Puppeteer configured for web browsing
- Default CLAUDE.md with Git commit guidelines

## Installation

New installations use the `install-zaneyos.sh` script which:

1. Prompts for hostname and hardware profile
2. Creates a new host configuration
3. Generates hardware configuration
4. Sets up user variables
5. Rebuilds the system

