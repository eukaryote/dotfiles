#!/bin/sh -eu

# Launch firefox with a forked mount table that binds /home
# to an empty directory.

mkdir -p /tmp/firefox

#sudo unshare bash -c "mount -o bind /tmp/firefox /home ; sudo -u $(whoami) firefox -ProfileManager -no-remote"
#sudo unshare -m bash -c "mount --make-rslave /home ; mount -n --make-rprivate -o bind /tmp/firefox /home ; sudo -u $(whoami) firefox -ProfileManager -no-remote"
