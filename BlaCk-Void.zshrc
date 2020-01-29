##-------------------------Init------------------------
export BVZSH=${0:a:h}

BVFPATH=${BVZSH}/autoload
fpath+="${BVFPATH}"
if [[ -d "$BVFPATH" ]]; then
    for func in $BVFPATH/*; do
        autoload -Uz ${func:t}
    done
fi
unset BVFPATH

# If not Interactively.
case $- in
    *i*);;
    *) return 0;;
esac

##-------------------------Zplugin set-------------------------
ZPLGIN_BIN=~/.zinit/bin/zinit.zsh
source $ZPLGIN_BIN
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
autoload -Uz cdr
autoload -Uz chpwd_recent_dirs

##-------------------------Theme Set
local ztheme=~/.ztheme
if [ -e $ztheme ]; then
    source $ztheme
else
    source $BVZSH/BlaCk-Void.ztheme
fi

if [ -z "$BVZSH_THEME" ] ; then
    export BVZSH_THEME='auto'
fi
_zsh-theme $BVZSH_THEME

##-------------------------Plugin Set
if type tmux &>/dev/null; then
    export TMUX_ENABLE=true
fi

##---------- Bundles from the oh-my-zsh.
_OMZ_SETTING() {
  #-----Thefuck
  eval "$(thefuck --alias)"

}

##---------- Bundles form the custom repo.
_alias-tip-setting() {
  export ZSH_PLUGINS_ALIAS_TIPS_FORCE=0
}

_enhancd-setting() {
  export ENHANCD_FILTER=fzf:fzy:peco
}

_zsh-history-substring-search-setting() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
}

_zsh-git-smart-commands-setting() {
  alias c='git-smart-commit'
  alias a='git-smart-add'
  alias p='git-smart-push seletskiy'
  alias u='git-smart-pull'
  alias r='git-smart-remote'
  alias s='git status'
}

_fzf-widgets-setting() {
  # Map widgets to key
  export DOT_BASE_DIR=$BVZSH
  bindkey '^fw' fzf-select-widget
  bindkey '^f.' fzf-edit-dotfiles
  bindkey '^fc' fzf-change-directory
  bindkey '^fn' fzf-change-named-directory
  bindkey '^ff' fzf-edit-files
  bindkey '^fk' fzf-kill-processes
  bindkey '^fs' fzf-exec-ssh
  bindkey '^\'  fzf-change-recent-directory
  bindkey '^r'  fzf-insert-history
  bindkey '^xf' fzf-insert-files
  bindkey '^xd' fzf-insert-directory
  bindkey '^xn' fzf-insert-named-directory

  ## Git
  bindkey '^fg'  fzf-select-git-widget
  bindkey '^fga' fzf-git-add-files
  bindkey '^fgc' fzf-git-change-repository

  # GitHub
  bindkey '^fh'  fzf-select-github-widget
  bindkey '^fhs' fzf-github-show-issue
  bindkey '^fhc' fzf-github-close-issue

  ## Docker
  bindkey '^fd'  fzf-select-docker-widget
  bindkey '^fdc' fzf-docker-remove-containers
  bindkey '^fdi' fzf-docker-remove-images
  bindkey '^fdv' fzf-docker-remove-volumes

  # Enable Exact-match by fzf-insert-history
  FZF_WIDGET_OPTS[insert-history]='--exact'

  # Start fzf in a tmux pane
  if [[ $TMUX_ENABLE ]]; then
      FZF_WIDGET_TMUX=1
  fi
}

_zsh-notify-setting() {
  zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
  zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"
}

_zsh-lazyenv-setting() {
  export ZSH_EVALCACHE_DIR=${BVZSH}/cache
  lazyenv-enabled
}

##-------------------------Plugin Load
##---------- Bundles from the oh-my-zsh.
# https://github.com/zdharma/zinit/issues/119
ZSH="$HOME/.zinit/plugins/robbyrussell---oh-my-zsh/"
local _OMZ_SOURCES=(
    # Libs
    lib/compfix.zsh
    lib/directories.zsh
    lib/functions.zsh
    lib/git.zsh
    lib/termsupport.zsh

    # Plugins
    plugins/autojump/autojump.plugin.zsh
    plugins/command-not-found/command-not-found.plugin.zsh
    plugins/fzf/fzf.plugin.zsh
    plugins/git/git.plugin.zsh
    plugins/gitfast/gitfast.plugin.zsh
    plugins/pip/pip.plugin.zsh
    plugins/sudo/sudo.plugin.zsh
    plugins/thefuck/thefuck.plugin.zsh
    plugins/urltools/urltools.plugin.zsh
)
if [[ $TMUX_ENABLE ]]; then
    export TMUX_ENABLE=true
    _OMZ_SOURCES=(
        $_OMZ_SOURCES
        plugins/tmux/tmux.plugin.zsh
        plugins/tmuxinator/tmuxinator.plugin.zsh
    )
fi

zinit ice from"gh" pick"/dev/null" nocompletions blockf lucid \
        multisrc"${_OMZ_SOURCES}" compile"(${(j.|.)_OMZ_SOURCES})" \
        atinit"_zpcompinit-custom; zpcdreplay" atload"_OMZ_SETTING" wait"1c"
zinit light robbyrussell/oh-my-zsh

##---------- Bundles form the custom repo.
zinit light chrissicool/zsh-256color
#zinit light mafredri/zsh-async ## PLugin to enable initialization of multiple jobs in ZSH
zinit light romkatv/powerlevel10k

zinit ice wait"0a" atload"_zsh_highlight" lucid
zinit light zdharma/fast-syntax-highlighting                  # Fast syntax highlighting
zinit ice wait"0a" compile'{src/*.zsh,src/strategies/*}' atload"_zsh_autosuggest_start" lucid
zinit light zsh-users/zsh-autosuggestions                     # ZSH autosuggestions
zinit ice wait"0b" lucid
zinit light hlissner/zsh-autopair                             # Autopair
zinit ice wait"0b" blockf lucid
zinit light zsh-users/zsh-completions                         # Zsh autocompletions and defining custom functions starting with _
zinit ice wait"0c" atload"_enhancd-setting" lucid
zinit light b4b4r07/enhancd                                   # better way to change directories or lookup from recent
zinit ice wait"0c" atload"_zsh-history-substring-search-setting" lucid
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"1a" atload"_alias-tip-setting" lucid
zinit light djui/alias-tips
zinit ice wait"1b" atload"_zsh-git-smart-commands-setting" blockf lucid
zinit light seletskiy/zsh-git-smart-commands
zinit ice wait"1b" atload"_fzf-widgets-setting" lucid
zinit light ytet5uy4/fzf-widgets

zinit ice wait"2" lucid
zinit light wfxr/forgit ## fzf + git
zinit ice wait"2" lucid
zinit light peterhurford/up.zsh ## plugin for ....... (cd ....... instead of defining the alias)
zinit ice wait"2" lucid
zinit light jocelynmallon/zshmarks ## Bookmarking the folders
zinit ice wait"2" lucid
zinit light changyuheng/zsh-interactive-cd ## fzf + cd (to a folder)

## plugin to notify for long running commands in zsh
#zinit ice wait"2" atload"_zsh-notify-setting" lucid
#zinit light marzocchi/zsh-notify

zinit ice wait"2" atload"_zsh-lazyenv-setting" lucid
zinit light black7375/zsh-lazyenv ## Speed up the loading time of zsh
zinit ice wait"2" pick"h.sh" lucid
zinit light paoloantinori/hhighlighter ## highlights words in the output on the terminal
zinit ice wait"2" as"program" pick"tldr" lucid
zinit light raylee/tldr ## use TLDR to get concise help on commands


_zpcompinit-custom
zinit cdreplay -q

##-------------------------From bashrc-------------------------
## enable color support of ls and also add handy aliases
#if [ -x /usr/bin/dircolors ]; then
#    test -r ~/.dircolors && evalcache dircolors -b ~/.dircolors || eval "$(dircolors -b)"
#    alias ls='ls --color=auto'
#    alias dir='dir --color=auto'
#    alias vdir='vdir --color=auto'
#
#    alias grep='grep --color=auto'
#    alias fgrep='fgrep --color=auto'
#    alias egrep='egrep --color=auto'
#fi

# some more ls aliases (Loading better aliases file
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

##-------------------------Custom set-------------------------
setopt nonomatch
setopt interactive_comments
setopt correct
setopt noclobber
setopt complete_aliases
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# eliminates duplicates in *paths
typeset -gU cdpath fpath path

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval $(SHELL=/bin/sh lesspipe)

# Alias
alias tar-compress-gz='tar -zcvf'
alias tar-extract-gz='tar -zxvf'
alias map='telnet mapscii.me'
alias prettyping='$BVZSH/prettyping'
alias rsync-ssh='rsync -avzhe ssh --progress'
alias ~='cd ~'
alias /='cd /'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less
alias bc='bc -l'
alias sha1='openssl sha1'

# Apple Terminal New Tab
if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]
then
  function chpwd {
    printf '\e]7;%s\a' "file://$HOSTNAME${PWD// /%20}"
  }

  chpwd
fi

##-------------------------Library set
#-----Completion
BVFPATH=${BVZSH}/completion
fpath+="${BVFPATH}"
unset BVFPATH

source $BVZSH/lib/completion.zsh

#-----Fzf
source $BVZSH/lib/fzf-set.zsh

##-------------------------Autoupdate Check
_zsh-auto-update
