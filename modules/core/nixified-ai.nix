{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nixified-ai.nixosModules.comfyui];

  services.comfyui = {
    enable = false;
  };
}
