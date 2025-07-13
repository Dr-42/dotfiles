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

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

export PATH="$PATH:/home/spandan/sdks/flutter/bin"
export PATH="$PATH:/home/spandan/.local/bin"
export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:/home/spandan/.cargo/bin"
export PATH="$PATH:/home/spandan/.deno/bin"
export PATH="$PATH:/opt/android-sdk/platform-tools/"

export PATH="$PATH:/home/spandan/.local/share/nvim/lazy/zotcite/python3"

export CHROME_EXECUTABLE="chromium-browser"
export ANDROID_HOME="/home/spandan/Android/Sdk"
export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
export JAVA_HOME="/home/spandan/android-studio/jbr"

export MANPAGER="nvim +Man!"

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=1000
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

export LD_LIBRARY_PATH=/home/spandan/.local/lib/arch-mojo:$LD_LIBRARY_PATH
export MODULAR_HOME="/home/spandan/.modular"
export PATH="/home/spandan/.modular/pkg/packages.modular.com_mojo/bin:$PATH"

# Cargo specific
export RUSTC_WRAPPER=sccache
