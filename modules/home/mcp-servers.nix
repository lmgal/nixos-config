{
  inputs,
  pkgs,
  config,
  lib,
  browser-control-mcp,
  ...
}: let
  # Define MCP servers configuration using mcp-servers-nix
  mcpServersConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
    programs = {
      # Filesystem access
      filesystem = {
        enable = true;
        args = [
          "${config.home.homeDirectory}"
          "${config.home.homeDirectory}/zaneyos"
          "${config.home.homeDirectory}/calibre"
          "${config.home.homeDirectory}/Downloads"
        ];
      };

      # Git integration
      git = {
        enable = true;
      };

      # Web content fetching
      fetch = {
        enable = true;
      };

      # # GitHub integration
      # github = {
      #   enable = true;
      # };

      # Time utilities
      # time = {
      #   enable = true;
      #   env = {
      #     TZ = "Australia/Melbourne";
      #   };
      # };

      # Memory/notes
      memory = {
        enable = true;
      };
    };

    # Custom MCP servers not in the predefined list
    settings.servers = {
      browser-control = {
        command = "${pkgs.nodejs}/bin/node";
        args = ["${browser-control-mcp}/dist/server.js"];
        env = {
          EXTENSION_SECRET = "40426403-bca4-4d2e-90a3-b2dc411c66d4"; # To be configured after Firefox extension installation
        };
      };
    };
  };
in {
  # Link the generated MCP servers config directly to Claude Desktop config
  home.file.".config/Claude/claude_desktop_config.json" = {
    source = mcpServersConfig;
    force = true;
  };

  # For Claude Code, we need to extract just the mcpServers part
  # Use an activation script to generate the settings file
  home.activation.claudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Read the MCP servers config
    MCP_CONFIG=$(cat ${mcpServersConfig})

    # Extract just the mcpServers object
    MCP_SERVERS=$(echo "$MCP_CONFIG" | ${pkgs.jq}/bin/jq '.mcpServers')

    # Create the Claude Code settings with MCP servers
    CLAUDE_SETTINGS=$(echo '{}' | ${pkgs.jq}/bin/jq \
      --argjson servers "$MCP_SERVERS" \
      '. + {
        "includeCoAuthoredBy": false,
        "model": "sonnet",
        "mcpServers": $servers
      }')

    # Write the settings file
    mkdir -p $HOME/.claude
    echo "$CLAUDE_SETTINGS" > $HOME/.claude/settings.json
  '';

  # Also ensure the Claude Code CLAUDE.md is created
  home.file.".claude/default/CLAUDE.md".text = ''
    # Claude Code Configuration

    ## Git Commit Guidelines

    - Do not include attribution to Claude in the commit message
    - Do not add co-author attribution

    ## MCP Servers

    This Claude Code instance is configured with MCP servers for:
    - Filesystem access to home directory and key project folders
    - Git integration for version control operations
    - Web content fetching
    - GitHub API access
    - Time utilities
    - Memory/notes functionality
    - Brave search integration
    - Firefox browser control (requires Firefox extension installation)
  '';

  # Ensure environment variable for co-authorship is set
  home.sessionVariables = {
    CLAUDE_DISABLE_CO_AUTHORSHIP = "1";
  };
}
