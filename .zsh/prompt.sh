# let's make an awesome prompt

autoload colors
if [[ ${terminfo[colors]} -ge 8 ]] then
  colors
fi
autoload -Uz vcs_info

# brackets
local op="%{$fg[green]%}[%{$reset_color%}"
local cp="%{$fg[green]%}]%{$reset_color%}"

# vcs config
zstyle ':vcs_info:*' enable git
# changes are slow, so it's on trial
local vcs_action="(%a)" # e.g. (rebase-i)
local vcs_branch="%b%u%c" # e.g. master(*)(s)
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '(*)'  # display [u] if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '(s)'    # display [s] if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats " ${op}%{$fg[cyan]%}${vcs_branch}${vcs_action}%{$reset_color%}${cp}"
zstyle ':vcs_info:*:prompt:*' formats " ${op}%{$fg[cyan]%}${vcs_branch}%{$reset_color%}${cp}"
zstyle ':vcs_info:*:prompt:*' nvcsformats ""

# every option takes care of their own leading space

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

local user_host=" ${op}${user}${host}${cp}"

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
local path_p=" ${op}%{$fg[cyan]%}%~%{$reset_color%}${cp}"

# current VCS status
local vcs='$vcs_info_msg_0_'
# smiley based on return status
local smiley="${op}%(?,%{$fg[red]%}<3%{$reset_color%},%{$fg_bold[red]%}>3%{$reset_color%})${cp}"
# last command, used in PS2
local cur_cmd="${op}%_${cp}"

PROMPT="${date}${path_p}${vcs}${user_host}${arch}${bell}
${smiley}${mc} # "
PROMPT2="${cur_cmd}> "
