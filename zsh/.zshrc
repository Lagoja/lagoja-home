# add devbox bits to zsh
fpath+=($DEVBOX_GLOBAL_PREFIX/share/zsh/site-functions $DEVBOX_GLOBAL_PREFIX/share/zsh/$ZSH_VERSION/functions $DEVBOX_GLOBAL_PREFIX/share/zsh/vendor-completions)
autoload -U compinit && compinit
# initialize apps
# direnv
eval "$(direnv hook zsh)"
# atuin
if [[ $options[zle] = on ]]; then
  eval "$(atuin init zsh )"
fi
# starship
eval "$(starship init zsh)"
# zoxide
eval "$(zoxide init zsh)"
