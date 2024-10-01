export ENABLE_CORRECTION="true"
fastfetch

alias vim='nvim'
alias ls='eza --icons --group-directories-first'
alias cd='z'

# Flatpak aliases
alias bottles='flatpak run com.usebottles.bottles'
alias blender='flatpak run org.blender.Blender'
alias obsidian='flatpak run md.obsidian.Obsidian'
alias cozy='flatpak run com.github.geigi.cozy'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# flutter sdk
export PATH="$PATH:/home/spandan/sdks/flutter/bin"
export PATH="$PATH:/home/spandan/.local/bin"
export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:/home/spandan/.cargo/bin"
export CHROME_EXECUTABLE="chromium-browser"

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

autoload -Uz compinit && compinit

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Home, end and delete keys
bindkey '\e[H'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[3~' delete-char

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/fzf/shell/key-bindings.zsh
