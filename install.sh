#!/bin/bash

# Error handling
set -e

# Colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths and directories
BASE_DIR="$(pwd)"
CONFIG_DIR="${BASE_DIR}/config"
PATCH_DIR="${BASE_DIR}/patch"
DWM_DIR="${BASE_DIR}/dwm"
SLOCK_DIR="${BASE_DIR}/slock"
SLSTATUS_DIR="${BASE_DIR}/slstatus"
DMENU_DIR="${BASE_DIR}/dmenu"
ST_DIR="${BASE_DIR}/st"

# List of tools to install
TOOLS=("dwm" "st" "dmenu" "slock" "slstatus")

# Logging functions
log() {
    echo -e "${GREEN}[LOG]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check for root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error "This script must be run with root privileges."
        error "Please run again with 'sudo'."
        exit 1
    fi
}

# Function to detect the operating system
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS=$DISTRIB_ID
    else
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    fi

    echo $OS
}

# Function to install dependencies
install_dependencies() {
    local os=$1
    local dep_log="dependencies.log"
    log "Installing dependencies for $os..."
    case $os in
        debian|ubuntu)
            apt-get update > "$dep_log" 2>&1
            apt-get install -y build-essential libx11-dev libxft-dev libxinerama-dev >> "$dep_log" 2>&1
            ;;
        fedora)
            dnf groupinstall -y "Development Tools" > "$dep_log" 2>&1
            dnf install -y libX11-devel libXft-devel libXinerama-devel >> "$dep_log" 2>&1
            ;;
        gentoo)
            emerge --ask x11-libs/libX11 x11-libs/libXft x11-libs/libXinerama > "$dep_log" 2>&1
            ;;
        arch)
            pacman -Syu --noconfirm base-devel libx11 libxft libxinerama > "$dep_log" 2>&1
            ;;
        *)
            error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
    if [ $? -eq 0 ]; then
        log "Dependencies installed successfully."
    else
        error "Failed to install dependencies. Check $dep_log for details."
        exit 1
    fi
}

# Function to install a single tool
install_tool() {
    local tool=$1
    log "Installing $tool..."
    if [ -d "$tool" ]; then
        if (cd "$tool" && ../install-tool.sh); then
            log "$tool installation completed successfully."
        else
            error "Failed to install $tool."
            return 1
        fi
    else
        warn "Directory for $tool not found. Skipping."
    fi
}

# Main function
main() {
    log "Starting Suckless tools installation process..."

    # Check for root privileges
    check_root

    # Detect OS and install dependencies
    OS=$(detect_os)
    log "Detected operating system: $OS"
    install_dependencies "$OS"

    # Install tools
    for tool in "${TOOLS[@]}"; do
        install_tool "$tool"
    done

    log "All tools installation process completed."
}

# Call the main function
main