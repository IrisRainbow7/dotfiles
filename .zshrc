alias gitlog='git log --oneline --decorate --graph'
alias ls='ls -G'
alias gitcommit='git commit -v'
alias phpstan='docker run -v $PWD:/app --rm phpstan/phpstan'
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.vim'

alias go="nocorrect go"


alias vim="nocorrect nvim"


fvim() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | fzf -m --preview 'head -100 {}') &&
  vim $selected_files
}


export TERM=screen-256color
export LANG=ja_JP.UTF-8

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kohki/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kohki/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kohki/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kohki/google-cloud-sdk/completion.zsh.inc'; fi
