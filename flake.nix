{
  description = "NixOS Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:nix-community/stylix/release-25.05";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixified-ai.url = "github:nixified-ai/flake";
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    mcp-servers-nix,
    claude-code,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    host = "lmgallos";
    profile = "amd";
    username = "lmgallos";

    # Create overlay to access unstable packages
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      amd = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/amd
          {
            nixpkgs.overlays = [
              overlay-unstable
              claude-code.overlays.default
              mcp-servers-nix.overlays.default
            ];
          }
        ];
      };
      nvidia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/nvidia
          {
            nixpkgs.overlays = [
              overlay-unstable
              claude-code.overlays.default
              mcp-servers-nix.overlays.default
            ];
          }
        ];
      };
      nvidia-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/nvidia-laptop
          {
            nixpkgs.overlays = [
              overlay-unstable
              claude-code.overlays.default
              mcp-servers-nix.overlays.default
            ];
          }
        ];
      };
      intel = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/intel
          {
            nixpkgs.overlays = [
              overlay-unstable
              claude-code.overlays.default
              mcp-servers-nix.overlays.default
            ];
          }
        ];
      };
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/vm
          {
            nixpkgs.overlays = [
              overlay-unstable
              claude-code.overlays.default
              mcp-servers-nix.overlays.default
            ];
          }
        ];
      };
    };
  };
}
