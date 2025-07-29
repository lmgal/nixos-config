{pkgs, ...}: {
  hardware = {
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };
    logitech.wireless.enable = false;
    logitech.wireless.enableGraphical = false;
    graphics.enable = true;
    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    amdgpu.opencl.enable = true;
    amdgpu.amdvlk.enable = true;
    opentabletdriver.enable = true;
    opentabletdriver.daemon.enable = true;
  };
  local.hardware-clock.enable = false;
}
