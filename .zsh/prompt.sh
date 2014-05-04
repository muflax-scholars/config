# let's make an awesome prompt

autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi

# brackets
local op="%{$fg_bold[black]%}[%{$reset_color%}"
local cp="%{$fg_bold[black]%}]%{$reset_color%}"

# git config
function _prompt_git_dirty() {
  if [[ "$(command git config --get zsh.hide-dirty)" != "1" ]]; then
    # skip git_annexslow repos because they're super slow
    if [[ "$(_prompt_git_annex)" != "" ]]; then
      return
    fi

    # any (tracked) changes?
    if [[ -n "$(command git status -uno -s | tail -n 1)" ]]; then
      echo "(*)"
    fi
  fi
}
function _prompt_git_ahead() {
  if $(echo "$(command git log origin/$(git_branch)..HEAD 2> /dev/null)" | command grep '^commit' &> /dev/null); then
    echo "(^)"
  fi
}
function _prompt_git_behind() {
  if $(echo "$(command git log HEAD..origin/$(git_branch) 2> /dev/null)" | command grep '^commit' &> /dev/null); then
    echo "(v)"
  fi
}
function _prompt_git_annex() {
  echo "$(command git config --get annex.uuid 2> /dev/null)" || return
}

function _prompt_git() {
  # which git repo, if any, are we in?
  local git_p=$(git_path)
  case $git_p in
    $HOME)
      # warn if we're in ~/
      git_p="(~)"
      ;;
    "")
      # not in git
      return
      ;;
    *)
      # otherwise don't care about the path
      git_p=""
      ;;
  esac

  # legit repo, so let's get its status
  local git_d=$(_prompt_git_dirty)
  local git_a=$(_prompt_git_ahead)
  local git_v=$(_prompt_git_behind)
  local git_b=$(git_branch)

  echo "${op}%{$fg[cyan]%}${git_d}${git_a}${git_v}${git_b}${git_p}%{$reset_color%}${cp}"
}

# current git status (set via precmd in title.sh)
local vcs='$prompt_git_cached'

# current date
local date="${op}%{$fg[cyan]%}%*%{$reset_color%}${cp}"

# current user, with warning if root
if [ $(whoami) = "root" ]; then
  local user="%{$fg[red]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}"
elif [ $(whoami) = "amon" ]; then
  local user="" # save some space
else
  local user="%{$fg[cyan]%}%n@%{$reset_color%}"
fi

# current host, with warning if ssh
if [ -z $SSH_CONNECTION ]; then
  local host="%{$fg[cyan]%}%m%{$reset_color%}"
else
  local host="%{$fg[red]%}%m%{$reset_color%}"
fi

local user_host="${op}${user}${host}${cp}"

# warning if not 64bit
if [ $(uname -m) = "i686" ]; then
  local arch=" ${op}(i686)${cp}"
fi

# are we in an mc shell?
if [[ $MC_SID != "" ]]; then
  local mc=" ${op}%{$fg[cyan]%}°_°%{$reset_color%}${cp}"
fi

# alarm after successful command if in scratchpad
if [[ $STY =~ "^\d+\.scratchpad$" ]]; then
  local bell=""
fi

# current path
local path_p="${op}%{$fg[cyan]%}%~%{$reset_color%}${cp}"

# smiley based on return status
local smiley="%(?,%{$fg[red]%}<3%{$reset_color%},%{$fg_bold[red]%}>3%{$reset_color%})"
# last command, used in PS2
local cur_cmd="${op}%_${cp}"

if [ $timer_duration ]; then
  echo "?"
  if [[ $timer_duration -gt 1 ]]; then
    echo $timer_duration
  fi
fi

# show runtime of last command
local cmd_time='$timer_show'

PROMPT="${date}${path_p}${vcs}${user_host}${arch}${bell}${cmd_time}
${smiley}${mc} "
PROMPT2="${cur_cmd}> "

# title handling
function title() {
  # escape '%' chars in $1, make nonprintables visible
  local a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
    screen*)
      print -Pn "\e]2;$a @$2\a"  # plain xterm title
      print -Pn "\ek$a\e\\"      # screen title (in ^A")
      ;;
    rxvt*|xterm*)
      print -Pn "\e]2;$a @$2\a" # plain xterm title
      ;;
  esac
}

function precmd() {
  prompt_git_cached=$(_prompt_git)
  title "zsh" "%m"

  # how long did the command run?
  if [ $timer ]; then
    timer_duration=$(($SECONDS - $timer))
    unset timer

    if [[ $timer_duration -gt 0 ]]; then
      if [[ $timer_duration -ge 3600 ]]; then
        let "timer_hours = $timer_duration / 3600"
        let "remainder = $timer_duration % 3600"
        let "timer_minutes = $remainder / 60"
        let "timer_seconds = $remainder % 60"
        fancy_time="${timer_hours}h${timer_minutes}m${timer_seconds}s"
      elif [[ $timer_duration -ge 60 ]]; then
        let "timer_minutes = $timer_duration / 60"
        let "timer_seconds = $timer_duration % 60"
        fancy_time="${timer_minutes}m${timer_seconds}s"
      else
        fancy_time="${timer_duration}s"
      fi

      timer_show="${op}%{$fg[cyan]%}${fancy_time}%{$reset_color%}${cp}"
    else
      timer_show=""
    fi
  fi
}

# set simple screen title just before program is executed
function preexec() {
  case $TERM in
    screen*)
      local CMD=${1[(wr)^(*=*|sudo|-*)]}
      CMD=$(print -Pn "%15>~>$CMD" | tr -d "\n")
      echo -ne "\ek$CMD\e\\"
      ;;
  esac

  # keep track of how long a command runs
  timer=${timer:-$SECONDS}
}
