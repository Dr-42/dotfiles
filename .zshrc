export ENABLE_CORRECTION="true"
fastfetch

alias vim='nvim'
alias ls='eza --icons --group-directories-first'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
#source zsh syntax highlighting and autosuggestions on fedora

# flutter sdk
export PATH="$PATH:/home/spandan/sdks/flutter/bin"
export PATH="$PATH:/home/spandan/.local/bin"

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

eval "$(starship init zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Home, end and delete keys
bindkey '\e[H'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[3~' delete-char
