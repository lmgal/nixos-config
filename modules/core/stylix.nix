{
  pkgs,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) stylixImage;
in
{
  # Styling Options
  stylix = {
    enable = true;
    image = stylixImage;
    # base16Scheme = {
    #   base00 = "282936";
    #   base01 = "3a3c4e";
    #   base02 = "4d4f68";
    #   base03 = "626483";
    #   base04 = "62d6e8";
    #   base05 = "e9e9f4";
    #   base06 = "f1f2f8";
    #   base07 = "f7f7fb";
    #   base08 = "ea51b2";
    #   base09 = "b45bcf";
    #   base0A = "00f769";
    #   base0B = "ebff87";
    #   base0C = "a1efe4";
    #   base0D = "62d6e8";
    #   base0E = "b45bcf";
    #   base0F = "00f769";
    # };
    base16Scheme = {
      base00 = "101010";
      base01 = "252525";
      base02 = "464646";
      base03 = "525252";
      base04 = "ababab";
      base05 = "b9b9b9";
      base06 = "e3e3e3";
      base07 = "f7f7f7";
      base08 = "7c7c7c";
      base09 = "999999";
      base0A = "a0a0a0";
      base0B = "8e8e8e";
      base0C = "868686";
      base0D = "686868";
      base0E = "747474";
      base0F = "5e5e5e";
    };
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
