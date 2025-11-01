HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
unsetopt beep nomatch notify

### Zsh vim mode ###
bindkey -v
KEYTIMEOUT=5

# Change cursor shape for different vi modes.
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# fix cursor when exiting neovim
_fix_cursor() {
    echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)
### End of zsh vim mode

### The following lines were added by compinstall ###
zstyle :compinstall filename '/home/naowal/.zshrc'
autoload -Uz compinit
compinit
### End of lines added by compinstall ###

### Added by Zinit's installer ###
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
# zinit lucid light-mode compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' for sindresorhus/pure

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

zinit wait lucid light-mode for \
    as"program" \
    pick"$ZPFX/bin/git-*" \
    src"etc/git-extras-completion.zsh" \
    make"PREFIX=$ZPFX" \
    tj/git-extras
### End of Zinit plugins ###

### oh-my-posh prompt
eval "$(oh-my-posh --config 'montys' init zsh)"

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
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
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

alias ls="eza --icons -h";
alias ll="ls -l --git --git-repos"
alias l="ll -a"
alias la="ls -a"
alias getgpu="glxinfo | grep 'OpenGL renderer'"
alias cat="bat --theme=ansi"
alias dgpu-status="cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status"
alias tree="ls --tree";
alias gh='firefox https://$(git config remote.origin.url | cut -f2 -d@ | tr ':' /)'
alias hub='git'
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

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#283457 \
  --color=bg:#16161e \
  --color=border:#27a1b9 \
  --color=fg:#c0caf5 \
  --color=gutter:#16161e \
  --color=header:#ff9e64 \
  --color=hl+:#2ac3de \
  --color=hl:#2ac3de \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#2ac3de \
  --color=query:#c0caf5:regular \
  --color=scrollbar:#27a1b9 \
  --color=separator:#ff9e64 \
  --color=spinner:#ff007c \
"
### End of fzf-tab configuration ###


### Fix zsh-vi-mode on termux ###
setopt re_match_pcre

# Add ~/.local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"
