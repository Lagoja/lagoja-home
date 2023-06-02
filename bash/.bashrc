# direnv
eval "$(direnv hook bash)"
# atuin
[[ -f "${DEVBOX_GLOBAL_PREFIX}/share/bash/bash-preexec.sh" ]] && source "${DEVBOX_GLOBAL_PREFIX}/share/bash/bash-preexec.sh"
eval "$(atuin init bash)"
# starship
eval "$(starship init bash)"
# zoxide
eval "$(zoxide init bash)"
