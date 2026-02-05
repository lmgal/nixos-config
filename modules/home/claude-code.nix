{
  pkgs,
  config,
  lib,
  ...
}: {
  # Generate Claude Code settings
  home.activation.claudeCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Create the Claude Code settings with general configuration only
    CLAUDE_SETTINGS=$(echo '{}' | ${pkgs.jq}/bin/jq \
      '. + {
        "includeCoAuthoredBy": false,
        "model": "opusplan",
        "permissions": {
          "allow": ["WebFetch", "WebSearch", "mcp__filesystem__*", "mcp__context7__*"]
        },
        "enabledMcpjsonServers": ["filesystem", "context7"]
      }')

    # Write the settings file
    mkdir -p $HOME/.claude
    echo "$CLAUDE_SETTINGS" > $HOME/.claude/settings.json
  '';

  # Create the Claude Code CLAUDE.md
  home.file.".claude/default/CLAUDE.md".text = ''
    # Claude Code Configuration

    ## Git Commit Guidelines

    - Do not include attribution to Claude in the commit message
    - Do not add co-author attribution

    ## MCP Servers Guidelines

    - Use context7 for documentation as part of planning or coding
    - Do not use sequential thinking
  '';

  # Ensure environment variable for co-authorship is set
  home.sessionVariables = {
    CLAUDE_DISABLE_CO_AUTHORSHIP = "1";
  };
}

