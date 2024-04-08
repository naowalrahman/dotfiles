# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/naowal/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

### Zinit plugins ###
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit wait lucid light-mode for \
    zdharma-continuum/history-search-multi-word \
    Aloxaf/fzf-tab

zinit wait lucid light-mode for \
    OMZ::plugins/git/git.plugin.zsh \
    OMZ::plugins/archlinux/archlinux.plugin.zsh \
    OMZ::plugins/dirhistory/dirhistory.plugin.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    agkozak/zsh-z

zinit wait lucid light-mode for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit lucid wait'0a' for \
    as"program" \
    pick"$ZPFX/bin/git-*" \
    src"etc/git-extras-completion.zsh" \
    make"PREFIX=$ZPFX" \
    tj/git-extras
### End of Zinit plugins ###


### Conda initialize ### 
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/naowal/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/naowal/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/naowal/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/naowal/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
### End of conda initialize ### 

### Run onefetch on cd into git repo ###
cd() {
    if [ "$#" -eq 0 ]; then
        builtin cd
    else
        builtin cd "$*"
        if [ -d .git ]; then
            onefetch
        fi
    fi
}
### End of run onefetch ###

### Zsh z configuration ###
export ZSHZ_CASE=smart
export ZSHZ_CD=cd
### End of zsh z configuration ###

### Variables ###
export COLORTERM="truecolor"
export EDITOR="nvim"
export VISUAL="nvim"
export HOSTNAME="arch"
export LS_COLORS=$(vivid generate snazzy)

alias ls="eza --icons -h";
alias ll="ls -l --git --git-repos"
alias l="ll -a"
alias la="ls -a"
alias getgpu="glxinfo | grep 'OpenGL renderer'"
alias cat="bat"
alias dgpu-status="cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status"
alias inspiration="~/.local/bin/inspiration.sh"
alias tree="ls --tree";
alias gh='brave https://$(git config remote.origin.url | cut -f2 -d@ | tr ':' /)'
### End of variables ###

### Fzf-tab configuration ###
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
### End of fzf-tab configuration ###
