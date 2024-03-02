alias gitlog='git log --oneline --decorate --graph'
alias gitcommit='git commit -v'
alias gitpush='git push origin HEAD'
alias zshrc='vim ~/.zshrc'


alias oldvim="nocorrect nvim"
alias vim="NVIM_APPNAME=nvimlua /Users//.local/nvim/bin/nvim"

if [[ $(command -v eza) ]]; then
  alias ls='eza --icons --git'
  alias la='eza -ahl --icons --git'
  alias ll='eza -ahl -I ".DS_Store" --git'
  alias lt='eza -T -L 3 -a -I "node_modules|.git|.cache|.DS_Store" --icons'
  alias ltl='eza -T -L 3 -a -I "node_modules|.git|.cache|.DS_Store" -l --icons'
fi

fvim() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | sk --ansi -m --preview 'bat --color=always --theme=TwoDark --style=numbers --line-range=:500 {}' | tr "\n" " ") &&
  vim ${=selected_files}
}

frvim() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | sk --ansi -i -c 'rg --color=always --line-number "{}"') &&
  selected_file_name = echo $selected_files | awk '{print $1}' | awk -F'[:]' '{print $1}'
  vim $selected_file_name
}

export TERM=screen-256color
export LANG=ja_JP.UTF-8
export EDITOR=vim

export PATH="/usr/local/bin/git:$PATH"

#nodebrew用
export PATH=$HOME/.nodebrew/current/bin:$PATH

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

setopt print_eight_bit
setopt no_beep
setopt auto_cd
setopt correct


autoload -Uz colors
colors
autoload -Uz compinit
compinit
#大文字小文字を区別しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${LS_COLORS}"

PROMPT="%{${fg[green]}%}%n: %{${fg[cyan]}%}%~ %{${reset_color}%}$ "

autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'


function crontab() {
  local opt
  for opt in "$@"; do
    if [[ $opt == -r ]]; then
      echo 'crontab -r is sealed!'
      return 1
    fi
  done
  command crontab "$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/mysql-client/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
eval "$(rbenv init - zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# bun completions
[ -s "/Users/koki.hirai/.bun/_bun" ] && source "/Users/koki.hirai/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/koki.hirai/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/koki.hirai/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/koki.hirai/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/koki.hirai/google-cloud-sdk/completion.zsh.inc'; fi
