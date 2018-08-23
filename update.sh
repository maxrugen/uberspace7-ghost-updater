#!/usr/bin/bash

# uberspace7-ghost-updater by Max Rugen
# Please share if this script works for you

# Store current version number in $VERSION variable
printf "Getting current version number...\n\n"
export VERSION=$(curl -s "https://github.com/TryGhost/Ghost/releases/latest" | grep -o 'tag/[v.0-9]*' | awk -F/ '{print $2}')

# Check if release needs to be redownloaded
if [ ! -d "$HOME/ghost/versions/$VERSION" ]; then

  # Download current release as zip file
  printf "\nDownloading current release...\n\n\n"
  wget https://github.com/TryGhost/Ghost/releases/download/$VERSION/Ghost-$VERSION.zip

  # Unzip downloaded file into a subdirectory
  printf "\nUnzipping file...\n\n\n"
  unzip Ghost-$VERSION -d $HOME/ghost/versions/$VERSION

  # Remove zip file which is no longer needed
  printf "\nRemoving zip file...\n\n\n"
  rm Ghost-$VERSION.zip

fi

  # Install current new version
  printf "\nInstalling new Ghost version...\n\n\n"
  cd $HOME/ghost/versions/$VERSION/content
  npm install --production

  # Replace symlink to newest version
  printf "\n\nReplacing symlink with symlink for the newest Ghost version...\n\n"
  rm $HOME/ghost/current
  ln -s $HOME/ghost/versions/$VERSION $HOME/ghost/current

  # Restart the Ghost blog's process
  printf "\nRestarting Ghost process...\n\n\n"
  supervisorctl restart ghost
  echo
  supervisorctl status

  printf "\n\nIf Ghost's state is not \"running\", please check your configuration.\nA comprehensive tutorial can be found at https://lab.uberspace.de/en/guide_ghost.html.\n"

