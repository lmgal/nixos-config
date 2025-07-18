{
  pkgs,
  lib,
  ...
}: let
  browser-control-mcp = pkgs.runCommand "browser-control-mcp-1.5.0" {
    src = pkgs.fetchurl {
      url = "https://github.com/eyalzh/browser-control-mcp/releases/download/v1.5.0/mcp-server-v1.5.0.dxt";
      sha256 = "0mbzjqzlcz13wa78bbrwlly2qny9178yh1g7w7rm51pj0ra8kg3f";
    };
    nativeBuildInputs = [ pkgs.unzip ];
  } ''
    mkdir -p $out
    cd $out
    unzip $src
    # Ensure the server.js is executable
    chmod +x dist/server.js
  '';
  
  # Package metadata for compatibility
  browser-control-mcp-meta = {
    pname = "browser-control-mcp";
    version = "1.5.0";
    description = "Firefox browser control MCP server";
    homepage = "https://github.com/eyalzh/browser-control-mcp";
    license = lib.licenses.mit;
    maintainers = [];
  };
in {
  # Make the package available
  home.packages = [browser-control-mcp];
  
  # Export the package for use in other modules
  _module.args.browser-control-mcp = browser-control-mcp;
}