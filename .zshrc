clear
fastfetch
setopt CORRECT
export EDITOR=nvim
alias vim='nvim'
alias ls='eza --icons --group-directories-first'
alias cd='z'
alias :qa='exit'
alias :q='exit'
alias :wq='exit'
alias :wqa='exit'
alias :w='exit'
alias :qa='exit'
alias :q='exit'
alias :wq='exit'
alias :wqa='exit'
alias :w='exit'
alias :qa='exit'
alias parup='paru -Syu --noconfirm && flatpak update -y'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

export PATH="$PATH:/home/spandan/.local/bin"
export PATH="$PATH:/opt/miniforge/bin"
export INCLUDE="$INCLUDE:/home/spandan/.local/include"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/spandan/.local/lib"

export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:/home/spandan/.cargo/bin"
export PATH="$PATH:/opt/android-sdk/platform-tools/"

export PATH="$PATH:/home/spandan/.local/share/nvim/lazy/zotcite/python3"

export MANPAGER="nvim +Man!"

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory

autoload -Uz compinit && compinit

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Home, end and delete keys
bindkey '\e[H'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[3~' delete-char

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/fzf/key-bindings.zsh

# pnpm
export PNPM_HOME="/home/spandan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/miniforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniforge/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniforge/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniforge/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
#
