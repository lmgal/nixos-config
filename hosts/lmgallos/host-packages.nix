{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    slack
    droidcam
    obs-studio
    libreoffice-qt
    hunspell
    hunspellDicts.en_AU
    librechat
    age
  ];
}
