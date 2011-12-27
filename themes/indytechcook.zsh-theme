function hg_prompt_info {
    hg prompt --angle-brackets "\
<hg:%{$fg[magenta]%}<branch>%{$reset_color%}>\
</%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[red]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo 'Hg' && return
    echo '○'
}

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_IGNORE="%{$fg[red]%} i"

function mygit() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  git_ignored_remotes=${git_ignored_remotes:=()}
  for local_remote ($(git_remotes)); do
    # from http://stackoverflow.com/questions/5203665/zsh-check-if-string-is-in-array
    if [[ ${git_ignored_remotes[(i)${local_remote}]} -le ${#git_ignored_remotes} ]] then
      echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_IGNORE%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      return
    fi
  done
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$( git_prompt_status )%{$reset_color%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Get a list of the remote repositories
function git_remotes() {
  git remote -v | cut -f 2 | cut -d " " -f 1 | cut -d @ -f 2
}

function rvminfo {
	echo %{$reset_color%}%{$fg[red]%}$(rvm_prompt_info)%{$reset_color%}
}

# alternate prompt with git & hg
PROMPT=$'%{\e[0;34m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}%m%{\e[0;34m%}%B]%b%{\e[0m%} - %b%{\e[0;34m%}%B[%b%{\e[1;37m%}%~%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[%b%{\e[0;33m%}'%D{"%Y-%m-%d %I:%M:%S"}%b$'%{\e[0;34m%}%B]%b%{\e[0m%} - %{\e[0;34m%}%B[$(rvminfo)%{\e[0;34m%}%B]
%{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B] <$(mygit)$(hg_prompt_info)%{\e[0;34m%}%B>%{\e[0;34m%}%b '
PS2=$' \e[0;34m%}%B>%{\e[0;34m%}%b '



