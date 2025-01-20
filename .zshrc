# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/spandan/.zsh/completions:"* ]]; then export FPATH="/home/spandan/.zsh/completions:$FPATH"; fi
export ENABLE_CORRECTION="true"
fastfetch

export EDITOR=nvim
alias vim='nvim'
alias ls='eza --icons --group-directories-first'
alias cd='z'

# Flatpak aliases
alias bottles='flatpak run --env="GSK_RENDERER=ngl" com.usebottles.bottles'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

export PATH="$PATH:/home/spandan/sdks/flutter/bin"
export PATH="$PATH:/home/spandan/.local/bin"
export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:/home/spandan/.cargo/bin"
export PATH="$PATH:/home/spandan/.deno/bin"
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
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
