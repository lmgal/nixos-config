{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Enable Claude OpenAI Wrapper service
  services.claude-openai-wrapper = {
    enable = true;
    port = 11435;
    # Optional: Set API key if you don't want interactive prompt
    # apiKey = "your-api-key-here";
  };
}
