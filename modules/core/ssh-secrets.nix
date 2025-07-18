{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.services.ssh-secrets;
  
  # Path to the age identity file
  ageIdentityFile = "/home/${username}/nixos-config/age-identity.txt";
  
  # Paths
  secretsDir = "/home/${username}/nixos-config/secrets";
  sshDir = "/home/${username}/.ssh";
  encryptedArchive = "${secretsDir}/ssh-keys.tar.age";
  
  # SSH key decryption script
  decryptScript = pkgs.writeShellScript "decrypt-ssh-keys" ''
    set -euo pipefail
    
    # Colors for output
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m'
    
    echo -e "''${YELLOW}Decrypting SSH keys from archive...''${NC}"
    
    # Check if encrypted archive exists
    if [[ ! -f "${encryptedArchive}" ]]; then
      echo -e "''${YELLOW}No encrypted SSH archive found at ${encryptedArchive}''${NC}"
      # Fall back to old method if archive doesn't exist
      if [[ -d "${secretsDir}/ssh" ]]; then
        echo -e "''${YELLOW}Falling back to individual file decryption...''${NC}"
        exec ${pkgs.bash}/bin/bash -c '${legacyDecryptScript}'
      fi
      exit 0
    fi
    
    # Create SSH directory if it doesn't exist
    mkdir -p "${sshDir}"
    
    # Create temporary directory for extraction
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    
    echo -e "''${GREEN}Decrypting archive...''${NC}"
    
    # Decrypt the archive
    if ! ${pkgs.age}/bin/age -d -i "${ageIdentityFile}" "${encryptedArchive}" > "$TEMP_DIR/ssh-keys.tar"; then
      echo -e "''${RED}✗ Failed to decrypt SSH archive''${NC}"
      exit 1
    fi
    
    echo -e "''${GREEN}Extracting SSH files...''${NC}"
    
    # Extract the archive
    if ! tar -xf "$TEMP_DIR/ssh-keys.tar" -C "$TEMP_DIR"; then
      echo -e "''${RED}✗ Failed to extract SSH archive''${NC}"
      exit 1
    fi
    
    # Remove the tar file from temp directory
    rm -f "$TEMP_DIR/ssh-keys.tar"
    
    # Copy files to SSH directory and set permissions
    file_count=0
    for file in "$TEMP_DIR"/*; do
      if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        output_file="${sshDir}/$filename"
        
        # Make existing file writable if it exists
        if [[ -f "$output_file" ]]; then
          chmod u+w "$output_file"
        fi
        
        # Copy the file
        cp "$file" "$output_file"
        
        # Set appropriate permissions
        case "$filename" in
          *.pub|known_hosts*)
            chmod 644 "$output_file"
            ;;
          *)
            chmod 600 "$output_file"
            ;;
        esac
        
        echo -e "''${GREEN}✓ Restored: $filename''${NC}"
        file_count=$((file_count + 1))
      fi
    done
    
    echo -e "''${GREEN}SSH key decryption completed: $file_count files processed''${NC}"
    
    # Ensure SSH directory has correct permissions
    chmod 700 "${sshDir}"
    chown -R ${username}:users "${sshDir}"
  '';
  
  # Legacy decryption script for backward compatibility
  legacyDecryptScript = ''
    set -euo pipefail
    
    # Colors for output
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RED='\033[0;31m'
    NC='\033[0m'
    
    echo -e "''${YELLOW}Using legacy individual file decryption...''${NC}"
    
    secretsDir="${secretsDir}/ssh"
    
    # Check if secrets directory exists
    if [[ ! -d "$secretsDir" ]]; then
      echo -e "''${YELLOW}No SSH secrets directory found at $secretsDir''${NC}"
      exit 0
    fi
    
    # Function to decrypt a single file
    decrypt_file() {
      local encrypted_file="$1"
      local filename=$(basename "$encrypted_file" .age)
      local output_file="${sshDir}/$filename"
      
      # Skip if encrypted file is older than existing decrypted file
      if [[ -f "$output_file" && "$encrypted_file" -ot "$output_file" ]]; then
        return 0
      fi
      
      echo -e "''${GREEN}Decrypting: $filename''${NC}"
      
      # Make existing file writable if it exists
      if [[ -f "$output_file" ]]; then
        chmod u+w "$output_file"
      fi
      
      # Decrypt the file
      if ${pkgs.age}/bin/age -d -i "${ageIdentityFile}" "$encrypted_file" > "$output_file"; then
        # Set appropriate permissions
        case "$filename" in
          *.pub|known_hosts*)
            chmod 644 "$output_file"
            ;;
          *)
            chmod 600 "$output_file"
            ;;
        esac
        
        echo -e "''${GREEN}✓ Decrypted: $filename''${NC}"
      else
        echo -e "''${RED}✗ Failed to decrypt: $filename''${NC}"
        rm -f "$output_file"
        return 1
      fi
    }
    
    # Decrypt all .age files in secrets directory
    success_count=0
    total_count=0
    
    for encrypted_file in "$secretsDir"/*.age; do
      if [[ -f "$encrypted_file" ]]; then
        total_count=$((total_count + 1))
        if decrypt_file "$encrypted_file"; then
          success_count=$((success_count + 1))
        fi
      fi
    done
    
    if [[ $total_count -eq 0 ]]; then
      echo -e "''${YELLOW}No encrypted SSH keys found''${NC}"
    else
      echo -e "''${GREEN}SSH key decryption completed: $success_count/$total_count keys processed''${NC}"
    fi
    
    # Ensure SSH directory has correct permissions
    chmod 700 "${sshDir}"
    chown -R ${username}:users "${sshDir}"
  '';
in {
  options.services.ssh-secrets = {
    enable = lib.mkEnableOption "SSH secrets decryption service";
  };
  
  config = lib.mkIf cfg.enable {
    systemd.services.ssh-keys-decrypt = {
      description = "Decrypt SSH keys from secrets directory";
      after = ["local-fs.target"];
      wantedBy = ["multi-user.target"];
      restartIfChanged = true;
      
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${decryptScript}";
        User = username;
        Group = "users";
        RemainAfterExit = false;
        
        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "full";
        ProtectHome = false; # Need access to home directory
      };
      
      path = with pkgs; [
        age
        coreutils
        gnused
        gnugrep
        gnutar
      ];
    };
    
  };
}