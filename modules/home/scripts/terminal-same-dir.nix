{ pkgs }:

pkgs.writeShellScriptBin "terminal-same-dir" ''
  # terminal-same-dir: Open a new ghostty terminal in the same directory as the currently focused one
  #
  # This script works by:
  # 1. Getting the currently focused window from Hyprland
  # 2. If it's a ghostty window, finding the shell process running inside it
  # 3. Reading the shell's current working directory from /proc/PID/cwd
  # 4. Launching a new ghostty instance in that directory
  #
  # Debug mode: Set TERMINAL_SAME_DIR_DEBUG=1 to see debug output
  
  DEBUG=''${TERMINAL_SAME_DIR_DEBUG:-0}
  
  debug() {
      if [[ "$DEBUG" == "1" ]]; then
          echo "[terminal-same-dir] $*" >&2
      fi
  }

  # Get the currently focused window info
  WINDOW_INFO=$(${pkgs.hyprland}/bin/hyprctl activewindow -j 2>/dev/null)
  if [[ -z "$WINDOW_INFO" ]]; then
      debug "Failed to get window info from hyprctl"
      exec ${pkgs.ghostty}/bin/ghostty
      exit
  fi

  # Extract class and PID
  WINDOW_CLASS=$(echo "$WINDOW_INFO" | ${pkgs.jq}/bin/jq -r '.class // empty' 2>/dev/null)
  WINDOW_PID=$(echo "$WINDOW_INFO" | ${pkgs.jq}/bin/jq -r '.pid // empty' 2>/dev/null)
  
  debug "Window class: $WINDOW_CLASS"
  debug "Window PID: $WINDOW_PID"

  # Default directory
  DIR="$HOME"

  # Function to find shell processes recursively
  find_shell_cwd() {
      local pid=$1
      local depth=''${2:-0}
      
      # Prevent infinite recursion
      if [[ $depth -gt 5 ]]; then
          return 1
      fi
      
      debug "Checking PID $pid at depth $depth"
      
      # Check if this process is a shell
      if [[ -e "/proc/$pid/exe" ]]; then
          local exe=$(readlink "/proc/$pid/exe" 2>/dev/null || true)
          debug "  Executable: $exe"
          
          case "$exe" in
              */bash|*/zsh|*/fish|*/sh|*/nu)
                  # This is a shell, get its cwd
                  if [[ -e "/proc/$pid/cwd" ]]; then
                      local cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null || true)
                      if [[ -d "$cwd" ]]; then
                          debug "  Found shell cwd: $cwd"
                          echo "$cwd"
                          return 0
                      fi
                  fi
                  ;;
          esac
      fi
      
      # Check child processes
      local children=$(pgrep -P "$pid" 2>/dev/null || true)
      if [[ -n "$children" ]]; then
          for child_pid in $children; do
              local result=$(find_shell_cwd "$child_pid" $((depth + 1)))
              if [[ -n "$result" ]]; then
                  echo "$result"
                  return 0
              fi
          done
      fi
      
      return 1
  }

  # Check if the focused window is ghostty
  if [[ "$WINDOW_CLASS" == "com.mitchellh.ghostty" ]] || [[ "$WINDOW_CLASS" == "ghostty" ]]; then
      if [[ -n "$WINDOW_PID" ]]; then
          debug "Found ghostty window with PID $WINDOW_PID"
          
          # Search ONLY within the focused window's process tree
          FOUND_DIR=$(find_shell_cwd "$WINDOW_PID")
          
          if [[ -n "$FOUND_DIR" ]]; then
              DIR="$FOUND_DIR"
              debug "Using directory: $DIR"
          else
              debug "Could not find shell process for PID $WINDOW_PID, using default: $DIR"
          fi
      else
          debug "No PID for ghostty window"
      fi
  else
      debug "Focused window is not ghostty (class: $WINDOW_CLASS)"
  fi

  # Launch ghostty in the determined directory
  debug "Launching ghostty in: $DIR"
  
  # Create a temporary script that changes directory and starts the shell
  TEMP_SCRIPT=$(mktemp /tmp/ghostty-start-XXXXXX.sh)
  cat > "$TEMP_SCRIPT" << EOF
#!/usr/bin/env bash
cd "$DIR"
exec \$SHELL
EOF
  chmod +x "$TEMP_SCRIPT"
  
  # Launch ghostty with the script
  ${pkgs.ghostty}/bin/ghostty -e "$TEMP_SCRIPT"
  
  # Clean up (this might not run if exec is used above)
  rm -f "$TEMP_SCRIPT"
''