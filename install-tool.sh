#!/bin/bash

# Error handling
set -e

# Colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Function to perform git hard reset on the current tool directory
git_hard_reset() {
    local git_log="git.log"
    log "Performing git hard reset on the src directory..."
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        if git reset --hard HEAD > "$git_log" 2>&1 && git clean -fd >> "$git_log" 2>&1; then
            log "Git hard reset successful"
        else
            error "Git hard reset failed. Check $git_log for details."
            exit 1
        fi
    else
        warn "src is not a git repository. Skipping git reset."
    fi
}

# Function to apply patches in defined order
apply_patches() {
    local patches_dir="../patches"
    local patch_order_file="$patches_dir/patch_order.txt"
    local patch_log="patch.log"

    if [ ! -d "$patches_dir" ]; then
        warn "Patches directory not found. Skipping patch application."
        return 0
    fi

    if [ ! -f "$patch_order_file" ]; then
        warn "Patch order file not found. Skipping patch application."
        return 0
    fi

    while IFS= read -r patch_name || [[ -n "$patch_name" ]]; do
        patch_name=$(echo "$patch_name" | tr -d '[:space:]')
        if [ -z "$patch_name" ] || [[ "$patch_name" == \#* ]]; then
            continue  # Skip empty lines and comments
        fi

        local patch_file="$patches_dir/$patch_name"
        if [ -f "$patch_file" ]; then
            log "Applying patch: $patch_name"
           if patch -p1 < "$patch_file" >> "$patch_log" 2>&1; then
                log "Patch applied successfully: $patch_name"
            else
                error "Failed to apply patch: $patch_name. Check $patch_log for details."
                exit 1
            fi
        else
            error "Patch file not found: $patch_file"
            exit 1
        fi
    done < "$patch_order_file"
}

# Function to copy config file
copy_config() {
    local config_file="../config.h"
    if [ -f "$config_file" ]; then
        log "Copying config.h to src directory..."
        if cp "$config_file" .; then
            log "Config file copied successfully"
        else
            error "Failed to copy config file"
            exit 1
        fi
    else
        warn "Custom config.h not found. Will use default config."
    fi
}

# Function to compile and install
compile_and_install() {
    local compile_log="compile.log"

    log "Cleaning previous build..."
    if make clean > "$compile_log" 2>&1; then
        log "Clean successful"
    else
        error "Clean failed. Check $compile_log for details."
        exit 1
    fi

    copy_config

    log "Compiling the tool..."
    if make >> "$compile_log" 2>&1; then
        log "Compilation successful"
    else
        error "Compilation failed. Check $compile_log for details."
        exit 1
    fi

    log "Installing the tool..."
    if sudo make install >> "$compile_log" 2>&1; then
        log "Installation successful"
    else
        error "Installation failed. Check $compile_log for details."
        exit 1
    fi
}

# Main function
main() {
    # Get the name of the current directory (tool name)
    TOOL_NAME=$(basename "$PWD")
    log "Starting installation process for $TOOL_NAME..."

    if [ -d "src" ]; then
        cd src

        # Perform git hard reset on the current tool directory
        git_hard_reset

        # Apply patches
        apply_patches

        # Compile and Install
        compile_and_install

        log "$TOOL_NAME installation completed successfully!"

        cd ..
    else
        error "src directory not found"
        exit 1
    fi
}

# Call the main function
main