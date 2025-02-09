# 環境変数
export LANG=ja_JP.UTF-8

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 直前のコマンドの重複を削除
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
# username:directory$
RPROMPT='${vcs_info_msg_0_}'

# alias
alias ls='ls -aF'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cat='cat -n'
alias less='less -NM'
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g C='| xsel --clipboard --input'
alias chrome='google-chrome'

export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

#auto cd to push d and add completion for cd
DIRSTACKSIZE=100
setopt AUTO_PUSHD

autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'


#for bazel build tool
export PATH="$PATH:$HOME/bin"

# node and sls
# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
#[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
#[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
#[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if [ -f $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
#   alias grep='rg'
#   alias cat='bat'
#   alias find='fd'
#   alias ls='exa'
fi

# launch byobu
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true


# terminal set vim binding
bindkey -v
#bindkey -M viins "^R" history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line


VIMODE='[i]'
function zle-keymap-select zle-line-init zle-line-finish {
	case $KEYMAP in
		main|viins)
			PROMPT_2="%F{cyan}I%f"
			;;
		vicmd)
			PROMPT_2="%F{white}N%f"
			;;
	esac

	PROMPT='${PROMPT_2} %n:%F{green}%~%f%F{yellow}$%f '
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select


# enable cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*:*:cdr:*:*' menu selection
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default true
  if [ ! -d "$HOME/.cache/shell" ]; then
    mkdir -p "$HOME/.cache/shell"
  fi
  zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
  zstyle ':chpwd:*' recent-dirs-pushd true
fi

# set cdr
function fzf-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | fzf)"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N fzf-cdr
bindkey '^W' fzf-cdr

export PATH=$HOME/.local/bin:$PATH

### fzf customization

# enable fzf (CTRL-R for history search, CTRL-T for file search and paste, alt-c for cd)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# to print QUERY to top
export FZF_DEFAULT_OPTS="-e --prompt='QUERY> ' --layout=reverse --height 50%"

# preview by bat for ctrl-t
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :100 {}'"

# to print tree preview for alt-c
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# directly executing from history search 
fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# some plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
