##############################################
# environment variables
set -x LANG ja_JP.UTF-8
set -x TERM screen-256color

##############################################
# path

set -x PATH $HOME/my_bin $HOME/.nimble/bin $PATH
set -x PATH $HOME/.pub-cache/bin $PATH
set -x PATH `yarn global bin` $PATH
set -x PATH $PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin
set -x PATH /usr/local/opt/python/libexec/bin /usr/local/lib/python3.7/site-packages $PATH

if test (uname) = "Darwin"
  eval (rbenv init - | source)
end

##############################################
# key binding
function fish_user_key_bindings
  fish_default_key_bindings -M insert
  fish_vi_key_bindings
  bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  bind \cf peco_change_directory # Bind for peco change directory to Ctrl+F
  bind \cs peco_switch_tmux_session
end

##############################################
# message
set fish_greeting "\x -> 南無参照透明性"

##############################################
# prompt
set fish_git_dirty_color red
set fish_git_not_dirty_color yellow

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_diff (git diff)

  if test -n "$git_diff"
    echo (set_color $fish_git_dirty_color)$branch(set_color normal)
  else
    echo (set_color $fish_git_not_dirty_color)$branch(set_color normal)
  end
end

function fish_prompt
  printf '%s%s%s > ' (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

function fish_right_prompt -d 'Write out the right prompt'
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
  # if test -n "$git_dir"
  #   printf '[%s][%s@%s]' (parse_git_branch) (whoami) (hostname|cut -d . -f 1)
  # else
  #   printf '[%s@%s]' (whoami) (hostname|cut -d . -f 1)
  # end
  if test -n "$git_dir"
    printf '[%s]' (parse_git_branch)
  end
end

##############################################
# history
function sync_history --on-event fish_preexec
  history save
  history merge
end

##############################################
# alias
alias fig='docker compose'
alias fige='docker compose exec'
alias figr='docker compose run --rm'
alias figup='docker compose up -d'
alias figst='docker compose stop'
alias figre='docker compose restart'
alias figps='docker compose ps'

if test (uname) = "Darwin"
  alias rmt='rmtrash'
end
alias rm='rm -i'
alias tmux='tmux -u'
alias l='exa -hla --git'
alias ls='exa'

alias gf 'git fetch --prune'
alias gfa 'git fetch -a --prune'
alias gclone 'git clone'
alias gstash 'git stash'
alias gstasha 'git stash apply'
alias gp 'git pull'
alias gpu 'git push'
alias gs 'git switch'
alias gsc 'git switch -c'
alias gr 'git restore'
alias grs 'git restore --source'

##############################################
# neovim
if test (uname) = "Darwin"
  if test -f /usr/local/bin/nvim
    set -x EDITOR /usr/local/bin/nvim
    alias vi='/usr/local/bin/nvim'
    alias vim='/usr/local/bin/nvim'
  end
else
  if test -f /usr/bin/nvim
    set -x EDITOR /usr/bin/nvim
    alias vi='/usr/bin/nvim'
    alias vim='/usr/bin/nvim'
  end
end

##############################################
# direnv
# https://github.com/direnv/direnv
eval (direnv hook fish | source)

##############################################
# start ssh-agent
eval (ssh-agent -c) > /dev/null

##############################################
# alias hub
eval (hub alias -s) > /dev/null

##############################################
# thefuck
# https://github.com/nvbn/thefuck/wiki/Shell-aliases
thefuck --alias | source 
set -x THEFUCK_OVERRIDDEN_ALIASES 'docker-compose'

##############################################
# exit hook
function on_exit --on-process %self
  ##############################################
  # kill ssh-agent
  ssh-agent -k > /dev/null
end

# vim:set ft=fish:
