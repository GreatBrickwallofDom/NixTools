#!/bin/bash
# .bashrc

# Copy all custom bashrc files from local git dirs to get latest versions!
if [ -d "$(echo ~/GitRepos)" ]; then
  rsync -avP ~/GitRepos/catchall/scripts/*.bashrc.src.sh ~/scripts/.
  clear
fi

# Grab all of the custom bashrc files and source them
for file in $(/bin/ls ~/scripts | grep bashrc.src.sh); do
    #echo "$file"
    if [ -f ~/scripts/$file ]; then
      . ~/scripts/$file
    fi
done
