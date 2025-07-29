# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Repository Overview

This is a custom NixOS configuration system that provides a fully featured
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
- AI tools integration (nixified-ai, ollama, claude-code with nixos MCP server)
- Hardware-specific optimizations

## Common Commands

### System Rebuild

To rebuild the NixOS system after making changes:

```bash
# Using nix-helper (nh)
fr # alias for `nh os switch --hostname <profile>`

# Direct flake rebuild
sudo nixos-rebuild switch --flake ~/nixos-config/#<profile>
```

### Update System

To update packages and rebuild:

```bash
# Using nix-helper
nh os switch --hostname <profile> --update  # alias: fu

# Direct flake update
nix flake update ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config/#<profile>
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
- **NixOS MCP Server**: Provides real-time access to the entire NixOS ecosystem

## Working with NixOS Resources

This configuration includes the **nixos MCP server**, which gives Claude authoritative access to NixOS ecosystem data. This prevents hallucinations and provides accurate, up-to-date information about:

- **130,000+ NixOS packages** with search capabilities
- **NixOS configuration options** with detailed documentation
- **Home Manager settings** for user environment configuration
- **nix-darwin options** for macOS configurations
- **Package version history** with nixpkgs commit hashes for reproducible builds

### Recommended Usage

**Always leverage Claude's NixOS knowledge through the MCP server:**

- **Package Discovery**: Ask Claude to search for packages instead of guessing names
  - "Find packages related to video editing"
  - "Search for Python development tools"

- **Configuration Options**: Let Claude verify options exist before adding them
  - "What options are available for configuring SSH?"
  - "Show me Home Manager options for Git configuration"

- **Version Management**: Request specific package versions for reproducible builds
  - "Find the nixpkgs commit hash for Python 3.11.5"
  - "What versions of Firefox are available in nixpkgs?"

- **Documentation**: Ask Claude to explain configuration options and their usage
  - "Explain the services.xserver.enable option"
  - "What does programs.git.signing do in Home Manager?"

**Best Practices:**
- When uncertain about package availability, ask Claude to search first
- For version-specific requirements, request package history through Claude
- Use Claude to explore configuration options before implementing
- Let Claude validate syntax and option compatibility

## Installation

New installations use the `install-nixos.sh` script which:

1. Prompts for hostname and hardware profile
2. Creates a new host configuration
3. Generates hardware configuration
4. Sets up user variables
5. Rebuilds the system
