# Install zplugin if not installed
if [ ! -d "${HOME}/.zplugin" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
fi

module_path+=( "/home/rjain/.zplugin/bin/zmodules/Src" )
if [[ ! -a "$ZPLG_HOME/bin/zmodules/Src/zdharma/zplugin.bundle" ]] && [[ -a "$ZPLG_HOME/bin/zmodules/Src/zdharma/zplugin.so" ]]; then
  mv "$ZPLG_HOME/bin/zmodules/Src/zdharma/zplugin.so" "$ZPLG_HOME/bin/zmodules/Src/zdharma/zplugin.bundle"
fi

if [[ -a "$ZPLG_HOME/bin/zmodules/Src/zdharma/zplugin.bundle" ]]; then
  module_path+=("$HOME/.zplugin/bin/zmodules/Src")

  zmodload zdharma/zplugin
fi

zmodload zdharma/zplugin
# End of Install zplugin if not installed

# Sourcing bash aliases
#source ~/.bash_profile
source ~/dotfiles/.aliases

### Added by Zplugin's installer
source "$HOME/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk


### Added Plugins for ZSH
zplugin load hlissner/zsh-autopair
### End of Plugins for ZSH

# Two regular plugins loaded without tracking.
zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with tracking.
zplugin load zdharma/history-search-multi-word

## Initialize Conda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#    else
#        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<
