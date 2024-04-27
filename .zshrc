export ENABLE_CORRECTION="true"
fastfetch

alias vim='nvim'
alias ls='eza --icons --group-directories-first'
alias cd='z'
alias bottles='flatpak run com.usebottles.bottles'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# flutter sdk
export PATH="$PATH:/home/spandan/sdks/flutter/bin"
export PATH="$PATH:/home/spandan/.local/bin"
export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:/home/spandan/.cargo/bin"
export CHROME_EXECUTABLE="chromium"

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Home, end and delete keys
bindkey '\e[H'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[3~' delete-char

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -Uz compinit && compinit
