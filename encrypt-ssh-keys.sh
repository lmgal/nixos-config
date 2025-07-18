#!/usr/bin/env bash

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
SSH_DIR="$HOME/.ssh"
CONFIG_DIR="$HOME/nixos-config"
SECRETS_DIR="$CONFIG_DIR/secrets"
AGE_IDENTITY="$CONFIG_DIR/age-identity.txt"
OUTPUT_FILE="$SECRETS_DIR/ssh-keys.tar.age"

echo -e "${YELLOW}SSH Keys Encryption Script${NC}"
echo -e "${YELLOW}============================${NC}"

# Check if SSH directory exists
if [[ ! -d "$SSH_DIR" ]]; then
    echo -e "${RED}Error: SSH directory not found at $SSH_DIR${NC}"
    exit 1
fi

# Check if age identity file exists
if [[ ! -f "$AGE_IDENTITY" ]]; then
    echo -e "${RED}Error: Age identity file not found at $AGE_IDENTITY${NC}"
    exit 1
fi

# Create secrets directory if it doesn't exist
mkdir -p "$SECRETS_DIR"

# Create temporary directory for archiving
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${GREEN}Collecting SSH files...${NC}"

# Copy SSH files to temporary directory
cp -r "$SSH_DIR"/* "$TEMP_DIR/" 2>/dev/null || {
    echo -e "${RED}Error: Failed to copy SSH files${NC}"
    exit 1
}

# List what will be encrypted
echo -e "${YELLOW}Files to be encrypted:${NC}"
find "$TEMP_DIR" -type f -exec basename {} \; | sort

# Create tar archive
TEMP_ARCHIVE="$TEMP_DIR/ssh-keys.tar"
echo -e "${GREEN}Creating archive...${NC}"
tar -cf "$TEMP_ARCHIVE" -C "$TEMP_DIR" --exclude="ssh-keys.tar" .

# Encrypt the archive
echo -e "${GREEN}Encrypting archive...${NC}"
age -e -i "$AGE_IDENTITY" "$TEMP_ARCHIVE" > "$OUTPUT_FILE"

# Verify the encrypted file was created
if [[ -f "$OUTPUT_FILE" ]]; then
    FILE_SIZE=$(stat -c%s "$OUTPUT_FILE")
    echo -e "${GREEN}✓ Successfully created encrypted archive: $OUTPUT_FILE${NC}"
    echo -e "${GREEN}✓ Archive size: $FILE_SIZE bytes${NC}"
else
    echo -e "${RED}✗ Failed to create encrypted archive${NC}"
    exit 1
fi

echo -e "${GREEN}Encryption completed successfully!${NC}"
echo -e "${YELLOW}Note: The old individual .age files in secrets/ssh/ can be removed after testing${NC}"