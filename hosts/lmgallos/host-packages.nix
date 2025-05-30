{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    nodejs
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        pandas
        requests
      ]))
    slack
  ];
}
