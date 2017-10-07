# Execute commands at login post-zshrc (copied from prezto project)

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  zcompdump="${HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Source custom (ignored by git) login script if present.
if [[ -s "${HOME}/.zlogin-custom" ]]
then
    source "${HOME}/.zlogin-custom"
fi

## sublimeconf: filetype=shell
