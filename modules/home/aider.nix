{pkgs, ...}: {
  programs.aider-chat-full = {
    enable = true;
    environmentVariables = {
      AIDER_DARK_MODE = true;
    };
  };
}
