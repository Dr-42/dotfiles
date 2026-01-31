# Clear screen on start
clear
fastfetch

# Shell Options
setopt CORRECT
setopt appendhistory

# Environment Variables
export EDITOR=nvim
export MANPAGER="nvim +Man!"
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Aliases

# - Neovim
alias vim='nvim'

# - NixOS Management
alias nixedit='sudoedit /etc/nixos/configuration.nix'
alias nixup='sudo nixos-rebuild switch'

# - Eza as ls replacement
alias ls='eza --icons --group-directories-first' 

# Initialize starship
eval "$(starship init zsh)"


# PATH configuration
# Keep these for your local/rust/cargo tools
export PATH="$PATH:/home/spandan/.local/bin"
export INCLUDE="$INCLUDE:/home/spandan/.local/include"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/spandan/.local/lib"
export PATH="$PATH:/home/spandan/.cargo/bin"

# PNPM Configuration
export PNPM_HOME="/home/spandan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# Keybindings
bindkey '\e[H'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[3~' delete-char
