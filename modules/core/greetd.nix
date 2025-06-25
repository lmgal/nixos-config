{
  pkgs,
  username,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      default_session = {
        user = username;
        command = "${pkgs.hyprland}/bin/Hyprland";
      };
    };
  };
}
