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
          "${config.home.homeDirectory}/nixos-config"
          "${config.home.homeDirectory}/calibre"
          "${config.home.homeDirectory}/Downloads"
        ];
      };

      # # GitHub integration
      # github = {
      #   enable = true;
      # };

      # Git integration
      git.enable = true;
      context7.enable = true;
      memory.enable = true;
      sequential-thinking.enable = true;
    };

    # Custom MCP servers not in the predefined list
    settings.servers = {
      browser-control = {
        command = "${pkgs.nodejs}/bin/node";
        args = ["${browser-control-mcp}/dist/server.js"];
        env = {
          EXTENSION_SECRET = "40426403-bca4-4d2e-90a3-b2dc411c66d4"; # To be configured after Firefox extension installation
          EXTENSION_PORT = "8089";
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

  # Generate global MCP servers in ~/.claude.json for Claude Code
  home.activation.claudeCodeGlobalMcp = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CLAUDE_CONFIG_FILE="${config.home.homeDirectory}/.claude.json"

    # Create ~/.claude.json if it doesn't exist
    if [ ! -f "$CLAUDE_CONFIG_FILE" ]; then
      echo '{}' > "$CLAUDE_CONFIG_FILE"
    fi

    # Read the MCP servers config
    MCP_CONFIG=$(cat ${mcpServersConfig})

    # Extract just the mcpServers object, excluding sequential-thinking and convert to Claude Code format
    MCP_SERVERS=$(echo "$MCP_CONFIG" | ${pkgs.jq}/bin/jq '.mcpServers | del(.["sequential-thinking"]) | to_entries | map({key: .key, value: .value}) | from_entries')

    # Update ~/.claude.json with the MCP servers
    ${pkgs.jq}/bin/jq --argjson servers "$MCP_SERVERS" '. + {"mcpServers": $servers}' "$CLAUDE_CONFIG_FILE" > "$CLAUDE_CONFIG_FILE.tmp"
    mv "$CLAUDE_CONFIG_FILE.tmp" "$CLAUDE_CONFIG_FILE"
  '';

}
