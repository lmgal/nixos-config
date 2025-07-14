{ pkgs, ... }:

pkgs.writeShellScriptBin "claude-image-helper" ''
  #!/usr/bin/env bash
  
  # Claude Image Helper - Facilitates image workflows for Claude Code in Ghostty
  
  CLAUDE_IMG_DIR="$HOME/Pictures/claude-screenshots"
  mkdir -p "$CLAUDE_IMG_DIR"
  
  show_help() {
      echo "Claude Image Helper - Easy image workflows for Claude Code"
      echo ""
      echo "Usage: claude-image-helper [command]"
      echo ""
      echo "Commands:"
      echo "  capture     - Capture a screenshot and save to Claude screenshots directory"
      echo "  region      - Capture a region screenshot and save to Claude screenshots directory"
      echo "  window      - Capture current window and save to Claude screenshots directory"
      echo "  last        - Copy the path of the last screenshot to clipboard"
      echo "  list        - List recent screenshots in Claude directory"
      echo "  clean       - Remove old screenshots (older than 7 days)"
      echo "  help        - Show this help message"
      echo ""
      echo "After capturing, the file path will be copied to clipboard for easy pasting."
      echo "You can also drag the image file directly from $CLAUDE_IMG_DIR into Ghostty."
  }
  
  capture_screen() {
      local timestamp=$(date +%Y%m%d_%H%M%S)
      local filename="$CLAUDE_IMG_DIR/screenshot_$timestamp.png"
      
      grim "$filename"
      
      if [ $? -eq 0 ]; then
          echo "$filename" | wl-copy
          notify-send "Claude Screenshot" "Saved to: $filename\nPath copied to clipboard!"
          echo "Screenshot saved: $filename"
          echo "Path copied to clipboard - paste it in Claude Code or drag the file into Ghostty"
      else
          notify-send "Claude Screenshot" "Failed to capture screenshot" -u critical
          exit 1
      fi
  }
  
  capture_region() {
      local timestamp=$(date +%Y%m%d_%H%M%S)
      local filename="$CLAUDE_IMG_DIR/region_$timestamp.png"
      
      grim -g "$(slurp)" "$filename"
      
      if [ $? -eq 0 ]; then
          echo "$filename" | wl-copy
          notify-send "Claude Screenshot" "Region saved to: $filename\nPath copied to clipboard!"
          echo "Region screenshot saved: $filename"
          echo "Path copied to clipboard - paste it in Claude Code or drag the file into Ghostty"
      else
          notify-send "Claude Screenshot" "Failed to capture region" -u critical
          exit 1
      fi
  }
  
  capture_window() {
      local timestamp=$(date +%Y%m%d_%H%M%S)
      local filename="$CLAUDE_IMG_DIR/window_$timestamp.png"
      
      # Get the focused window's geometry
      local geometry=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
      
      if [ -n "$geometry" ]; then
          grim -g "$geometry" "$filename"
          
          if [ $? -eq 0 ]; then
              echo "$filename" | wl-copy
              notify-send "Claude Screenshot" "Window saved to: $filename\nPath copied to clipboard!"
              echo "Window screenshot saved: $filename"
              echo "Path copied to clipboard - paste it in Claude Code or drag the file into Ghostty"
          else
              notify-send "Claude Screenshot" "Failed to capture window" -u critical
              exit 1
          fi
      else
          notify-send "Claude Screenshot" "Failed to get window geometry" -u critical
          exit 1
      fi
  }
  
  get_last_screenshot() {
      local last_file=$(ls -t "$CLAUDE_IMG_DIR"/*.png 2>/dev/null | head -n1)
      
      if [ -n "$last_file" ]; then
          echo "$last_file" | wl-copy
          notify-send "Claude Screenshot" "Path copied: $last_file"
          echo "Last screenshot path copied to clipboard: $last_file"
      else
          notify-send "Claude Screenshot" "No screenshots found" -u warning
          echo "No screenshots found in $CLAUDE_IMG_DIR"
      fi
  }
  
  list_screenshots() {
      echo "Recent Claude screenshots:"
      echo "========================="
      ls -lt "$CLAUDE_IMG_DIR"/*.png 2>/dev/null | head -20 || echo "No screenshots found"
      echo ""
      echo "Drag any of these files into Ghostty to use with Claude Code"
  }
  
  clean_old_screenshots() {
      echo "Removing screenshots older than 7 days..."
      find "$CLAUDE_IMG_DIR" -name "*.png" -type f -mtime +7 -delete
      echo "Cleanup complete"
  }
  
  case "$1" in
      capture|screen)
          capture_screen
          ;;
      region)
          capture_region
          ;;
      window)
          capture_window
          ;;
      last)
          get_last_screenshot
          ;;
      list|ls)
          list_screenshots
          ;;
      clean)
          clean_old_screenshots
          ;;
      help|--help|-h|"")
          show_help
          ;;
      *)
          echo "Unknown command: $1"
          echo "Run 'claude-image-helper help' for usage information"
          exit 1
          ;;
  esac
''