{
  pkgs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # SurfingKeys
        "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/surfingkeys_ff/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}