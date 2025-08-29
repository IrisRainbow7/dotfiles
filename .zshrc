alias gitlog='git log --oneline --decorate --graph'
alias gitcommit='git commit -v'
alias gitpush='git push origin HEAD'
alias zshrc='vim ~/.zshrc'


alias vim="/Users/irisrainbow7/.local/nvim/bin/nvim"

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



eval "$(starship init zsh)"
