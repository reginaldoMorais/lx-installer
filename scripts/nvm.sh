#!/bin/sh

installNVM() {
  echo "\n\n\n  Install NVM"
  echo "++++++++++++++++++++++"
  echo "\n> Deseja instalar NVM? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh -P ~/Downloads | bash\n"
      sudo wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh -P ~/Downloads | bash

      echo "\n> sudo ./~/Downloads/install.sh\n"
      sudo ./~/Downloads/install.sh

      echo "\n> source ~/.bashrc\n"
      source ~/.bashrc

      echo "\n> nvm i --lts\n"
      nvm i --lts
    fi
  fi
}
