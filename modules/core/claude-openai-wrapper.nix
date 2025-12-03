{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.claude-openai-wrapper;
  
  # Create the Python package
  claude-openai-wrapper = pkgs.python311Packages.buildPythonApplication rec {
    pname = "claude-code-openai-wrapper";
    version = "1.0.0";
    
    src = pkgs.fetchFromGitHub {
      owner = "RichardAtCT";
      repo = "claude-code-openai-wrapper";
      rev = "5ae2bf0398ca81fbe4a7c541df29dd65c30a57b5";
      sha256 = "1crwbc7b007g687zljd7jizhmhb53wb4k55dirfskj9cbf7fvxqq";
    };
    
    format = "pyproject";
    
    nativeBuildInputs = with pkgs.python311Packages; [
      poetry-core
    ];
    
    # Patch pyproject.toml to relax version constraints and fix syntax error
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace '"^0.27.2"' '">=0.27.2"' \
        --replace '"^0.32.0"' '">=0.32.0"' \
        --replace '"^0.0.12"' '">=0.0.12"' \
        --replace '"^0.0.14"' '">=0.0.14"'
      
      # Fix the f-string syntax error - just comment out the problematic debug line
      sed -i '148s/.*/#&/' main.py
    '';
    
    propagatedBuildInputs = with pkgs.python311Packages; [
      fastapi
      uvicorn
      pydantic
      python-dotenv
      httpx
      sse-starlette
      python-multipart
      (buildPythonPackage rec {
        pname = "claude_code_sdk";
        version = "0.0.19";
        format = "wheel";
        src = pkgs.fetchurl {
          url = "https://files.pythonhosted.org/packages/a1/2d/e4826ae5d361b772218491e21a5dc6b8b98e66737e255bf2891c76b0305d/claude_code_sdk-0.0.19-py3-none-any.whl";
          sha256 = "0n3aplhyfjad2zvs8rkqvqxhxaphfjh7qg95s3kjvrcr06xacldl";
        };
      })
    ];
    
    # Create a wrapper script that runs the server
    postInstall = ''
      mkdir -p $out/bin
      cat > $out/bin/claude-wrapper << EOF
      #!/usr/bin/env python3
      import sys
      sys.path.insert(0, '$out/${pkgs.python311.sitePackages}')
      from main import run_server
      run_server()
      EOF
      chmod +x $out/bin/claude-wrapper
    '';
  };
in {
  options.services.claude-openai-wrapper = {
    enable = lib.mkEnableOption "Claude Code OpenAI API Wrapper";
    
    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port on which the service will listen";
    };
    
    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional API key for authentication. If not set, server will prompt interactively";
    };
    
    claudeCliPath = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.claude-code}/bin/claude";
      description = "Path to Claude CLI executable";
    };
    
    maxTimeout = lib.mkOption {
      type = lib.types.int;
      default = 600000;
      description = "Maximum timeout in milliseconds";
    };
    
    corsOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["*"];
      description = "Allowed CORS origins";
    };
    
    debugMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable debug logging";
    };
    
    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable verbose logging";
    };
  };
  
  config = lib.mkIf cfg.enable {
    systemd.services.claude-openai-wrapper = {
      description = "Claude Code OpenAI API Wrapper";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      
      environment = {
        PORT = toString cfg.port;
        CLAUDE_CLI_PATH = cfg.claudeCliPath;
        MAX_TIMEOUT = toString cfg.maxTimeout;
        CORS_ORIGINS = builtins.toJSON cfg.corsOrigins;
        DEBUG_MODE = if cfg.debugMode then "true" else "false";
        VERBOSE = if cfg.verbose then "true" else "false";
        HOME = "/home/lmgallos";  # Use actual home to access Claude auth
      } // (lib.optionalAttrs (cfg.apiKey != null) {
        API_KEY = cfg.apiKey;
      });
      
      serviceConfig = {
        Type = "simple";
        ExecStart = "${claude-openai-wrapper}/bin/claude-wrapper";
        Restart = "on-failure";
        RestartSec = 5;
        
        # Run as the actual user instead of DynamicUser to access Claude auth
        User = "lmgallos";
        Group = "users";
        
        # Security hardening (relaxed to allow home access)
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";  # Read-only access to home for Claude config
        
        # Working directory
        WorkingDirectory = "/home/lmgallos";
        
        ReadWritePaths = [
          # Claude needs to update its config files
          "/home/lmgallos/.claude.json"
          "/home/lmgallos/.claude"
        ];
      };
      
      path = with pkgs; [
        nodejs
        claude-code
      ];
    };
  };
}