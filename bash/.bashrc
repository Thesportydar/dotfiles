# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init bash)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# JAVA_HOME
export JAVA_HOME="/home/inaqui/.jdks/openjdk-23.0.2"
export PATH="$JAVA_HOME/bin:$PATH"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

fastfetch

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# # selector de snippets
# function snippet-fzf() {
#   local cmd
#   cmd=$(cat ~/.snippets/*.txt | cut -d '|' -f2- | fzf --prompt="⚡ Snippet > ")
#   if [[ -n "$cmd" ]]; then
#     eval "$cmd"
#   fi
# }
# selector de snippets mejorado
function snippet-fzf() {
  local snippet_file=~/.snippets/shortcuts.txt
  
  # Verificar si el archivo existe
  if [[ ! -f "$snippet_file" ]]; then
    echo "Error: No se encontró el archivo de snippets en $snippet_file"
    return 1
  fi

  local name cmd
  name=$(awk -F ' *\\| *' '{print $1}' "$snippet_file" | fzf --prompt="⚡ Snippet > " --height=40% --reverse)
  
  if [[ -n "$name" ]]; then
    # Extraer el comando exacto manteniendo los espacios originales
    cmd=$(awk -F ' *\\| *' -v name="$name" '$1 == name {sub($1 FS, ""); print}' "$snippet_file")
    
    if [[ -n "$cmd" ]]; then
      echo "Ejecutando: $cmd"
      eval "$cmd"
    else
      echo "Error: No se encontró el comando para '$name'"
    fi
  fi
}

function add-snippet() {
  echo "$1 | $2" >> ~/.snippets/shortcuts.txt
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"


function /ai() {
  local prompt="$*"

  if [[ -z "$prompt" ]]; then
    echo "uso: ai <lo-que-queres-hacer>"
    return 1
  fi

  llm prompt -m gemini-flash-latest --no-stream \
    -s "Convertí la intención del usuario en UN (1) comando de shell para debian + bash.
Devolvé únicamente el comando, sin backticks, sin markdown, sin explicación.
Si la intención es ambigua o peligrosa, devolvé un comando inofensivo que muestre ayuda (por ejemplo: 'echo ...')." \
    "$prompt" | tr -d '\r'
}
