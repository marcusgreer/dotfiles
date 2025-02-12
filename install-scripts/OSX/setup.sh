sudo chown -R $(whoami):admin /usr/local

#==================================
# Remove old dot flies
#==================================
sudo rm -rf ~/.vim > /dev/null 2>&1
sudo rm -rf ~/.vimrc > /dev/null 2>&1
sudo rm -rf ~/.zshrc > /dev/null 2>&1
sudo rm -rf ~/.zprofile > /dev/null 2>&1
sudo rm -rf ~/.gitconfig > /dev/null 2>&1
sudo rm -rf ~/Brewfile > /dev/null 2>&1

#==================================
# Create symlinks in the home folder
# Allow overriding with files of matching names in the custom-configs dir
#==================================

DOTFILE_SYMLINKS=()
# ln -sf ~/.dotfiles/vim ~/.vim
# SYMLINKS+=('.vim')
ln -sf ~/.dotfiles/vim/vimrc ~/.vimrc
DOTFILE_SYMLINKS+=('.vimrc')
ln -sf ~/.dotfiles/zsh/zshrc ~/.zshrc
DOTFILE_SYMLINKS+=('.zshrc')
ln -sf ~/.dotfiles/zsh/zprofile ~/.zprofile
DOTFILE_SYMLINKS+=('.zprofile')
ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig
DOTFILE_SYMLINKS+=('.gitconfig')
ln -s ~/.dotfiles/git/gitignore_global ~/.gitconfig
DOTFILE_SYMLINKS+=('.gitignore_global')
ln -sf ~/.dotfiles/homebrew/Brewfile ~/Brewfile
DOTFILE_SYMLINKS+=('Brewfile')

#==================================
# Install Homebrew Package Manager
#==================================
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH:
# TODO: Find a way to do this without continually adding the same line to .zprofile
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew doctor
brew update

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/homebrew/Brewfile

#==================================
# Install 1Password Password Manager
#==================================
brew install --cask 1password

#==================================
# Install VSCode 
#==================================
brew install visual-studio-code

#==================================
# Install Starship prompt
#==================================
brew install starship

#==================================
# END
#==================================
echo -e "\n====== All Done ======\n"
echo
echo "Enjoy!"

