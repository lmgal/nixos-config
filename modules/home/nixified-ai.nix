{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nixified-ai.nixOsModules.comfyui];

  services.comfyui.enable = true;
}
