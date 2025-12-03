#!/usr/bin/env bash

set -e  # Exit on error
set -u  # Exit on undefined variable

#==================================
# Configuration
#==================================
DOTFILES_DIR="${HOME}/.dotfiles"
BACKUP_DIR="${HOME}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

#==================================
# Colors for output
#==================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

#==================================
# Backup existing dotfiles
#==================================
backup_dotfiles() {
    log_info "Backing up existing dotfiles to ${BACKUP_DIR}..."
    
    local files_to_backup=(
        ".vimrc"
        ".vim"
        ".zshrc"
        ".zprofile"
        ".gitconfig"
        ".gitignore_global"
        ".config/fastfetch/config.jsonc"
        ".config/starship.toml"
    )
    
    local backed_up=false
    for file in "${files_to_backup[@]}"; do
        if [[ -e "${HOME}/${file}" ]] && [[ ! -L "${HOME}/${file}" ]]; then
            mkdir -p "${BACKUP_DIR}/$(dirname "$file")"
            mv "${HOME}/${file}" "${BACKUP_DIR}/${file}"
            log_warning "Backed up ${file}"
            backed_up=true
        fi
    done
    
    if [[ "$backed_up" == false ]]; then
        log_info "No existing files to backup"
        rmdir "${BACKUP_DIR}" 2>/dev/null || true
    else
        log_success "Backup completed at ${BACKUP_DIR}"
    fi
}

#==================================
# Create symlinks
#==================================
create_symlinks() {
    log_info "Creating symlinks..."
    
    local symlinks=(
        "${DOTFILES_DIR}/configs/vim/vimrc:${HOME}/.vimrc"
        "${DOTFILES_DIR}/configs/zsh/zshrc:${HOME}/.zshrc"
        "${DOTFILES_DIR}/configs/zsh/zprofile:${HOME}/.zprofile"
        "${DOTFILES_DIR}/configs/git/gitconfig:${HOME}/.gitconfig"
        "${DOTFILES_DIR}/configs/git/gitignore_global:${HOME}/.gitignore_global"
        "${DOTFILES_DIR}/configs/fastfetch/config.jsonc:${HOME}/.config/fastfetch/config.jsonc"
        "${DOTFILES_DIR}/configs/starship/starship.toml:${HOME}/.config/starship.toml"
    )
    
    for link in "${symlinks[@]}"; do
        local source="${link%%:*}"
        local target="${link##*:}"
        
        # Create parent directory if it doesn't exist
        mkdir -p "$(dirname "$target")"
        
        # Remove existing symlink or file
        rm -f "$target"
        
        # Create symlink
        if ln -sf "$source" "$target"; then
            log_success "Linked $(basename "$target")"
        else
            log_error "Failed to link $(basename "$target")"
        fi
    done
}

#==================================
# Install Homebrew
#==================================
install_homebrew() {
    if command -v brew &>/dev/null; then
        log_info "Homebrew already installed"
        log_info "Updating Homebrew..."
        brew update
    else
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    log_info "Running brew doctor..."
    brew doctor || log_warning "brew doctor reported some issues (this is often okay)"
}

#==================================
# Install packages from Brewfile
#==================================
install_packages() {
    local brewfile="${DOTFILES_DIR}/configs/homebrew/Brewfile"
    
    if [[ ! -f "$brewfile" ]]; then
        log_warning "Brewfile not found at ${brewfile}, skipping package installation"
        return
    fi
    
    log_info "Installing packages from Brewfile..."
    if brew bundle --file "$brewfile"; then
        log_success "Package installation completed"
    else
        log_error "Some packages failed to install"
    fi
}

#==================================
# Main execution
#==================================
main() {
    echo
    log_info "Starting dotfiles setup for macOS..."
    echo
    
    # Check if dotfiles directory exists
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found at ${DOTFILES_DIR}"
        exit 1
    fi
    
    # Backup existing files
    backup_dotfiles
    echo
    
    # Create symlinks
    create_symlinks
    echo
    
    # Install Homebrew
    install_homebrew
    echo
    
    # Install packages
    install_packages
    echo
    
    log_success "====== All Done ======"
    echo
    echo "🎉 Enjoy your new setup!"
    echo
    
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "💾 Your old dotfiles were backed up to:"
        echo "   ${BACKUP_DIR}"
        echo
    fi
}

# Run main function
main