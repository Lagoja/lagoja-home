set shell `ps -p $fish_pid | awk 'NR>1  {print $4}' | sed 's/-//g'`
set SCRIPT_PATH "$HOME/.local/share/devbox/global/current"

switch $(basename $shell)
     case "zsh"
            . $DEVBOX_GLOBAL_ROOT/zsh/.zshrc
     case "bash"
            . $DEVBOX_GLOBAL_ROOT/bash/.bashrc
     case * 
            
end

# zoxide
# zoxide for smart cd
alias cd='z'
# bat
# bat --plain for unformatted cat
alias catp='bat -P'
# replace cat with bat
alias cat='bat'
# devbox helpers
alias dbr='devbox run'
alias cddevbox='cd $DEVBOX_GLOBAL_ROOT'

