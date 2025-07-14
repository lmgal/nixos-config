{
  pkgs,
  lib,
  ...
}: let
  browser-control-mcp = pkgs.stdenv.mkDerivation rec {
    pname = "browser-control-mcp";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "eyalzh";
      repo = "browser-control-mcp";
      rev = "main";
      sha256 = "16x0hv49p2j12lhq3i9sbrxa59k9cr16r3iavh8h4c8cpr6mssn8";
    };

    nativeBuildInputs = with pkgs; [
      nodejs
      npm
    ];

    buildPhase = ''
      runHook preBuild
      cd mcp-server
      npm install
      npx tsc
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out/
      cp package.json $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Firefox browser control MCP server";
      homepage = "https://github.com/eyalzh/browser-control-mcp";
      license = licenses.mit;
      maintainers = [];
    };
  };
in {
  # Make the package available
  home.packages = [browser-control-mcp];
  
  # Export the package for use in other modules
  _module.args.browser-control-mcp = browser-control-mcp;
}