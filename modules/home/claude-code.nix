{
  config,
  lib,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    CLAUDE_DISABLE_CO_AUTHORSHIP = "1";
  };
  
  # Create default CLAUDE.md with co-authorship instructions
  home.file.".claude/default/CLAUDE.md".text = ''
    # Claude Code Configuration
    
    ## Git Commit Guidelines
    
    - Do not include attribution to Claude in the commit message
    - Do not add co-author attribution
  '';
}