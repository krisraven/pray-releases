#!/bin/bash

# Pray CLI Tool - Universal Installation Script
# Supports Linux and macOS

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="${INSTALL_DIR:-.}"
BINARY_NAME="pray"
QUOTES_FILE="quotes.json"

# Detect OS and architecture
detect_platform() {
    local os=$(uname -s)
    local arch=$(uname -m)

    case "$os" in
        Linux)
            case "$arch" in
                x86_64) echo "linux-amd64" ;;
                i686) echo "linux-386" ;;
                armv7l) echo "linux-arm" ;;
                aarch64) echo "linux-arm64" ;;
                *) echo ""; return 1 ;;
            esac
            ;;
        Darwin)
            case "$arch" in
                x86_64) echo "darwin-amd64" ;;
                arm64) echo "darwin-arm64" ;;
                *) echo ""; return 1 ;;
            esac
            ;;
        *)
            echo ""
            return 1
            ;;
    esac
}

# Show usage
usage() {
    cat << EOF
Pray CLI Tool - Installation Script

Usage: ./install.sh [OPTIONS]

Options:
  -d, --dir DIR       Installation directory (default: current directory)
  -g, --global        Install to /usr/local/bin (requires sudo)
  -h, --help          Show this help message

Examples:
  ./install.sh                    # Install to current directory
  ./install.sh -d ~/bin           # Install to ~/bin directory
  ./install.sh --global           # Install system-wide (needs sudo)

EOF
}

# Parse arguments
INSTALL_GLOBAL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -g|--global)
            INSTALL_GLOBAL=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Main installation logic
main() {
    echo -e "${BLUE}Pray CLI Tool - Installation${NC}\n"

    # Detect platform
    PLATFORM=$(detect_platform)
    if [ -z "$PLATFORM" ]; then
        echo -e "${RED}✗ Unsupported platform${NC}"
        echo "Your OS/architecture combination is not supported."
        echo "Please visit https://github.com/krisraven/pray-releases/releases for manual download"
        exit 1
    fi

    echo -e "${BLUE}Detected platform: ${PLATFORM}${NC}\n"

    # Determine installation directory
    if [ "$INSTALL_GLOBAL" = true ]; then
        INSTALL_DIR="/usr/local/bin"
        echo "Installing to: $INSTALL_DIR (requires sudo)"
    else
        INSTALL_DIR="${INSTALL_DIR%/}"  # Remove trailing slash
        echo "Installing to: $INSTALL_DIR"
    fi

    # Create directory if needed
    if [ ! -d "$INSTALL_DIR" ]; then
        if [ "$INSTALL_GLOBAL" = true ]; then
            echo "Creating directory..."
            sudo mkdir -p "$INSTALL_DIR"
        else
            mkdir -p "$INSTALL_DIR"
        fi
    fi

    # Get latest release version
    echo -e "\n${BLUE}Fetching latest version...${NC}"
    local latest_version=$(curl -fsSL -o /dev/null -w "%{redirect_url}" "https://github.com/krisraven/pray-releases/releases/latest" | grep -oP '[^/]+$')
    if [ -z "$latest_version" ]; then
        echo -e "${RED}✗ Failed to determine latest version${NC}"
        exit 1
    fi
    echo -e "Latest version: ${latest_version}"

    # Download binary
    echo -e "\n${BLUE}Downloading binary...${NC}"
    local binary_url="https://github.com/krisraven/pray-releases/releases/download/${latest_version}/pray-${PLATFORM}.tar.gz"

    local tmp_archive=$(mktemp /tmp/pray-XXXXXX.tar.gz)

    curl -fsSL -o "$tmp_archive" "$binary_url"
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Failed to download archive${NC}"
        rm -f "$tmp_archive"
        exit 1
    fi

    # Extract archive
    echo -e "${BLUE}Extracting...${NC}"
    if [ "$INSTALL_GLOBAL" = true ]; then
        sudo tar -xzf "$tmp_archive" --strip-components=1 -C "$INSTALL_DIR"
        sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
    else
        tar -xzf "$tmp_archive" --strip-components=1 -C "$INSTALL_DIR"
        chmod +x "$INSTALL_DIR/$BINARY_NAME"
    fi

    rm -f "$tmp_archive"

    # Verify installation
    echo -e "\n${BLUE}Verifying installation...${NC}"
    if [ -x "$INSTALL_DIR/$BINARY_NAME" ]; then
        echo -e "${GREEN}✓ Installation successful!${NC}\n"
        echo "Binary: $INSTALL_DIR/$BINARY_NAME"

        if [ "$INSTALL_GLOBAL" = true ]; then
            echo -e "\n${GREEN}You can now run:${NC} pray"
        else
            echo -e "\n${GREEN}Run the tool with:${NC} $INSTALL_DIR/$BINARY_NAME"

            # Add to PATH suggestion
            if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
                echo -e "\n${BLUE}To add to PATH, run:${NC}"
                echo "export PATH=\"\$PATH:$INSTALL_DIR\""
                echo "# Or add the above line to your ~/.bashrc or ~/.zshrc"
            fi
        fi
    else
        echo -e "${RED}✗ Installation failed${NC}"
        exit 1
    fi

    # Test the installation
    echo -e "\n${BLUE}Testing installation...${NC}"
    "$INSTALL_DIR/$BINARY_NAME"
}

main
