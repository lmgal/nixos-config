{
  pkgs,
  lib,
  ...
}: {
  programs.chromium = {
    enable = true;
    extensions = [
      "bjfgambnhccakkhmkepdoekmckoijdlc" # Browser MCP - Automate your browser
    ];
  };
}