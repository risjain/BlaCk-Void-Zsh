#!/bin/bash

echo "----------------------------------------"
echo "         BlaCk-Void Zsh Setup"
echo "----------------------------------------"

# Storing the default config directory
set -e
BVZSH=$( cd "$(dirname "$0")" ; pwd )

## Creating and setting default directories
mkdir ~/dotfiles
mkdir ~/dotfiles/.zsh
mkdir ~/dotfiles/.zsh/BlaCk_Void_dir

# Copying the latest setting files to the respective directory
cp -a * ~/dotfiles/.zsh/BlaCk_Void_dir

cd ~/dotfiles
dotfiles_dir=$( cd "$(dirname "$0")" ; pwd )

cd ~/dotfiles/.zsh
zsh_dir=$( cd "$(dirname "$0")" ; pwd )

# Moving back to the default config directory
cd $BVZSH

## Defining the function to create backup for a given file
set_file()
{
  local file=$1
  echo "-------"
  echo "Set $file !!"
  echo ""
  if [ -e $file ]; then
    echo "$file found."
    echo "Now Backup.."
    cp -v $file $file.bak
    echo ""
  else
    echo "$file not found."
    sudo touch $file
    echo "$file is created"
    echo ""
  fi
}

## Defining the function for installing Dependencies for Mac
MAC_PACKAGE_NAME="zsh autojump curl python git socat w3m wmctrl ack tmux xdotool"
MAC_CASK_PACKAGE_NAME="xquartz"

mac_install()
{
  brew update
  brew install $MAC_PACKAGE_NAME

  if ! [ -x "$(command -v pip)" ]; then
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py | sudo python get-pip.py
  fi
  sudo pip3 install powerline-status
}

## Defining the function for installing Homebrew for Mac
set_brew()
{
  if ! [ -x "$(command -v brew)" ]; then
    echo "Now, Install Brew." >&2
    if [[ "$OSTYPE" == "darwin"* ]]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
    fi
  fi
  {
    brew install fzf ripgrep thefuck
  } || {
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    brew vendor-install ruby
    brew install fzf ripgrep thefuck
  }
  $(brew --prefix)/opt/fzf/install
}

## Defining the function for installing Prettyping and Necessary fonts for Mac
etc_install()
{
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
  curl -L $BVZSH https://raw.githubusercontent.com/denilsonsa/prettyping/master/prettyping > $BVZSH/prettyping
  chmod +x $BVZSH/prettyping
  source $BVZSH/install_font.sh
}

## Beginning the downloads and installation
echo ""
echo "--------------------"
echo "  Downloads"
echo ""

## Install Brew and other packages
if [[ "$OSTYPE" == "darwin"*  ]]; then
  set_brew
  mac_install
else
  echo "Use the original installation file."
  exit 1;
fi

## Install the dependencies (additional fonts and prettyping)
etc_install
source $BVZSH/install_font.sh


## Applying additional settings
echo "--------------------"
echo "  Apply Settings"
echo ""

### Sourcing the folders for the target configuration files
mkdir $BVZSH/cache
zshrc=$zsh_dir/.zshrc
zshenv=$zsh_dir/.zshenv
zlogin=$zsh_dir/.zlogin
zprofile=$zsh_dir/.zprofile
profile=$zsh_dir/.profile

set_file $zshrc
set_file $zshenv
set_file $zlogin

### Copying the latest .zshrc, .zshenv, .zlogin files to the ZSH dotfiles directory
cp $BVZSH/BlaCk-Void.zshrc $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zshrc
cp $BVZSH/BlaCk-Void.zshenv $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zshenv
cp $BVZSH/BlaCk-Void.zlogin $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zlogin

# Add the default aliases to the zsh configuration
cp $BVZSH/.aliases $zsh_dir/ # copying the aliases to the configuration file
echo "source $zsh_dir/.aliases" | sudo tee -a $zshrc
source $HOME/.zshenv ## Reload ZSH environment


### Updating the zsh configurations to point to the new files
echo "source $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zshrc" | sudo tee -a $zshrc
echo "source $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zshenv" | sudo tee -a $zshenv
echo "source $zsh_dir/BlaCk_Void_dir/BlaCk-Void.zlogin" | sudo tee -a $zlogin

### Specifying the default theme
echo "" | sudo tee -a $zshrc
echo "# To customize prompt, run `p10k configure` or edit ~/dotfiles/.zsh/.p10k.zsh" | sudo tee -a $zshrc
echo "[[ ! -f ~/dotfiles/.zsh/.p10k.zsh ]] || source ~/dotfiles/.zsh/.p10k.zsh" | sudo tee -a $zshrc
echo "" | sudo tee -a $zshrc

## Exporting the default environment variables
echo "" | sudo tee -a $zshrc
echo "# Default Environment Variables" | sudo tee -a $zshrc
#echo "export BVZSH=$BVZSH" | sudo tee -a $zshrc
echo "export dotfiles_dir=$dotfiles_dir" | sudo tee -a $zshrc
echo "export zsh_dir=$zsh_dir" | sudo tee -a $zshrc
echo "" | sudo tee -a $zshrc

if [ -e $profile ]; then
    cat ~/.profile | tee -a $zprofile
fi

#Remove zplugin installer contents
if [[ "$OSTYPE" == "darwin"*  ]]; then
    sed -i '' "/[zZ]plugin/d" $zshrc
else
    sed -i    "/[zZ]plugin/d" $zshrc
fi

# Redirect the Zsource files to the new folder
src_zshenv=~/.zshenv
set_file $src_zshenv
echo "ZDOTDIR=~/dotfiles/.zsh" | sudo tee -a $src_zshenv

## Change the default shell
echo "-------"
echo "ZSH as the default shell(need sudo permission)"
chsh -s $(which zsh)

echo "Please relogin session or restart terminal"
echo "The End!!"
echo ""

echo "command: zsh-help"
echo "for BlaCk-Void Zsh update"
