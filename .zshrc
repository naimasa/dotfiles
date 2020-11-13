bindkey -v

autoload -U compinit; compinit

setopt auto_cd
alias ...='cd ../../'
alias ....='cd ../../../'
setopt auto_pushd
setopt pushd_ignore_dups

setopt extended_glob

setopt hist_ignore_all_dups
setopt hist_ignore_space

setopt no_beep

setopt prompt_subst

git_branch=''

function get-git-branch {
  git_branch=`git branch 2> /dev/null | grep '*' | tr -d '()'`
  # git_branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  # git_branch=`git name-rev --name-only HEAD 2> /dev/null`
  echo ${git_branch:2}
}

function print-git-branch {
  git_branch=`get-git-branch`
  if [[ -n $git_branch ]]; then
    git_branch='['${git_branch}']'
  fi
  echo $git_branch
}

function print-venv {
  venv=''
  if [[ -n $VIRTUAL_ENV ]]; then
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
      # special case for Aspen magic directories
      # see http://www.zetadev.com/software/aspen/
      venv="[`basename \`dirname \"$VIRTUAL_ENV\"\``] "
    else
      venv="(`basename \"$VIRTUAL_ENV\"`) "
    fi
  fi
  echo $venv
}


# prompt - Multiline RPROMPT in zsh - Super User https://superuser.com/questions/974908/multiline-rprompt-in-zsh
function precmd {
  print

  LEFT=`expr $HISTCMD - 0`
  RIGHT=`print-git-branch`" ["`pwd`"]"
  RIGHTWIDTH=$(($COLUMNS-${#LEFT}))
  print $LEFT${(l:$RIGHTWIDTH::.:)RIGHT}
}


function prompt {
  venv=`print-venv`
  echo $venv'%n@%m %c %# '
}
PROMPT=`prompt`

function rprompt {
  echo '%T'
}
RPROMPT=`rprompt`

