
# Automatically Starts ssh agent on Fish.
# https://gitlab.com/kyb/fish_ssh_agent

# Aliases. They make life easier.
alias ls="ls -lrth --color=auto"
alias k="kubectl"
alias kube="kubectl"
alias tf="terraform"
alias contexts="k config get-contexts"
alias con="k config get-contexts"
alias use="k config use-context"
alias nsp="k config set-context --current --namespace"

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
#export XDG_DATA_HOME="/data/jumpusers/$USER/.local/share"

#export PATH=$PATH:$HOME/.linkerd2/bin
#
cd $HOME
