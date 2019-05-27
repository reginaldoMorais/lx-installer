#!/bin/sh

installFranz() {
  echo "\n\n\n  Install Franz"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Franz? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.20/franz_5.0.0-beta.20_amd64.deb -P ~/Downloads | bash\n"
      sudo wget https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.20/franz_5.0.0-beta.20_amd64.deb -P ~/Downloads | bash

      echo "\n> dpkg -i ~/Downloads/franz_5.0.0-beta.20_amd64.deb\n"
      dpkg -i ~/Downloads/franz_5.0.0-beta.20_amd64.deb
    fi
  fi
}
