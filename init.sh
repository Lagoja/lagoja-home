shell=`ps -p $$ | awk 'NR>1  {print $4}' | sed 's/-//g'`
SCRIPT_PATH="$HOME/.local/share/devbox/global/current"

case $(basename $shell) in
     "zsh" )
            . $DEVBOX_GLOBAL_ROOT/zsh/.zshrc
           ;;
     "bash" )
            . $DEVBOX_GLOBAL_ROOT/bash/.bashrc
           ;;
     * )
           ;;
esac

# bat
# bat --plain for unformatted cat
alias catp='bat -P'
# replace cat with bat
alias cat='bat'
# zoxide
# zoxide for smart cd
alias cd='z'
# devbox helpers
alias dbr='devbox run'
alias cddevbox='cd $DEVBOX_GLOBAL_ROOT'

