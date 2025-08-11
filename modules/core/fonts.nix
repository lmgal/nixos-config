{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      # symbola # Temporarily disabled due to DNS issues with web.archive.org
      material-icons
      fira-code
      fira-code-symbols
    ];
  };
}
