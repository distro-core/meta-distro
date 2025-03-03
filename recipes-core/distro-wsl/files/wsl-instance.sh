# WSL Instance
# if [ "$USER" != "root" ] ; then
#   if [ -n "$USERPROFILE" ] ; then
#     if [ -d "$USERPROFILE" ] ; then
#       mkdir -p "$USERPROFILE/.config" && ln -sf "$USERPROFILE/.config" $HOME/.config && rm -f $HOME/.config/.config
#       mkdir -p "$USERPROFILE/.gnupg" && ln -sf "$USERPROFILE/.gnupg" $HOME/.gnupg && rm -f $HOME/.gnupg/.gnupg
#       mkdir -p "$USERPROFILE/.local/bin"
#       export PATH="$USERPROFILE/.local/bin:$PATH"
#       [[ -d $HOME/.ssh && ! -h $HOME/.ssh ]] && rm -fr $HOME/.ssh
#       mkdir -p "$USERPROFILE/.ssh" && ln -sf "$USERPROFILE/.ssh" $HOME/.ssh && rm -f $HOME/.ssh/.ssh
#       touch "$USERPROFILE/.netrc" && ln -sf "$USERPROFILE/.netrc" $HOME/.netrc
#       touch "$USERPROFILE/.s3cfg" && ln -sf "$USERPROFILE/.s3cfg" $HOME/.s3cfg
#       rm -fr $HOME/.config/systemd/user
#       rm -fr $HOME/.config/systemd/user.control
#     fi
#   fi
# fi
# export XDG_RUNTIME_DIR=/run/user/$(id -u)
# export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# dockerd-rootless.sh
