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
ln -sf ~/.dotfiles/git/gitconfig ~/.gitconfig
DOTFILE_SYMLINKS+=('.gitconfig')
ln -sf ~/.dotfiles/git/gitignore_global ~/.gitignore_global
DOTFILE_SYMLINKS+=('.gitignore_global')
ln -sf ~/.dotfiles/homebrew/Brewfile ~/Brewfile
DOTFILE_SYMLINKS+=('Brewfile')

#==================================
# TODO: figure out how to manage the creation of a new SSH Key for GH if necessary
#==================================


#==================================
# Install Homebrew Package Manager
#==================================
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew doctor
brew update

# Then pass in the Brewfile location...
brew bundle --file ~/.dotfiles/homebrew/Brewfile

#==================================
# END
#==================================
echo -e "\n====== All Done ======\n"
echo
echo "Enjoy!"

