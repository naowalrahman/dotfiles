
#######################################
#               Pacman                #
#######################################

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias paclean='sudo pacman -Sc'
alias pacins='sudo pacman -U'
alias paclr='sudo pacman -Scc'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias pacmir='sudo pacman -Syy'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -F'
alias pacls='pacman -Ql'
alias pacown='pacman -Qo'
alias pacupd="sudo pacman -Sy"

function paclist() {
  pacman -Qqe | xargs -I{} -P0 --no-run-if-empty pacman -Qs --color=auto "^{}\$"
}

function pacdisowned() {
  local tmp_dir db fs
  tmp_dir=$(mktemp --directory)
  db=$tmp_dir/db
  fs=$tmp_dir/fs

  trap "rm -rf $tmp_dir" EXIT

  pacman -Qlq | sort -u > "$db"

  find /etc /usr ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"

  rm -rf $tmp_dir
}

alias pacmanallkeys='sudo pacman-key --refresh-keys'

function pacmansignkeys() {
  local key
  for key in $@; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}

if (( $+commands[xdg-open] )); then
  function pacweb() {
    if [[ $# = 0 || "$1" =~ '--help|-h' ]]; then
      local underline_color="\e[${color[underline]}m"
      echo "$0 - open the website of an ArchLinux package"
      echo
      echo "Usage:"
      echo "    $bold_color$0$reset_color ${underline_color}target${reset_color}"
      return 1
    fi

    local pkg="$1"
    local infos="$(LANG=C pacman -Si "$pkg")"
    if [[ -z "$infos" ]]; then
      return
    fi
    local repo="$(grep -m 1 '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
    local arch="$(grep -m 1 '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
    xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
  }
fi

#######################################
#          Paru (AUR Helper)          #
#######################################

if (( $+commands[paru] )); then
  alias parclean='paru -Sc'
  alias parclr='paru -Scc'
  alias parupg='paru -Syu'
  alias parsu='paru -Syu --noconfirm'
  alias parin='paru -S'
  alias parins='paru -U'
  alias parre='paru -R'
  alias parrem='paru -Rns'
  alias parrep='paru -Si'
  alias parreps='paru -Ss'
  alias parloc='paru -Qi'
  alias parlocs='paru -Qs'
  alias parlst='paru -Qe'
  alias parorph='paru -Qtd'
  alias parinsd='paru -S --asdeps'
  alias parmir='paru -Syy'
  alias parupd="paru -Sy"
  
  # AUR-specific operations
  alias parsua='paru -Sua'       # Upgrade AUR packages only
  alias parqua='paru -Qua'       # List available AUR updates
  alias parget='paru -G'         # Download PKGBUILD
fi

#######################################
#         System Upgrade              #
#######################################

# Check Arch Linux PGP Keyring before System Upgrade to prevent failure.
function upgrade() {
  sudo pacman -Sy
  echo ":: Checking Arch Linux PGP Keyring..."
  local installedver="$(LANG= sudo pacman -Qi archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  local currentver="$(LANG= sudo pacman -Si archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  if [ $installedver != $currentver ]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -S --needed --noconfirm archlinux-keyring
  else
    echo " Arch Linux PGP Keyring is up to date."
    echo " Proceeding with full system upgrade."
  fi
  if (( $+commands[paru] )); then
    paru -Su
  else
    sudo pacman -Su
  fi
}
