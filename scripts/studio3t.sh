#!/usr/bin/env bash

installStudio3T() {
  echo "\n\n\n  Install Studio 3T"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Studio 3T? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget https://download.studio3t.com/studio-3t/linux/2018.5.1/studio-3t-linux-x64.tar.gz -O ~/Downloads | bash\n"
      sudo wget https://download.studio3t.com/studio-3t/linux/2018.5.1/studio-3t-linux-x64.tar.gz -O ~/Downloads/studio-3t.tar.gz | bash

      echo "\n> sudo tar -xzf ~/Downloads/studio-3t.tar.gz -C ~/Downloads\n"
      sudo tar -xzf ~/Downloads/studio-3t.tar.gz -C ~/Downloads

      echo "\n> sudo chmod 777 ~/Downloads/studio-3t-linux-x64.sh\n"
      sudo chmod 777 ~/Downloads/studio-3t-linux-x64.sh

      echo "\n> sudo sh ~/Downloads/studio-3t-linux-x64.sh\n"
      sudo sh ~/Downloads/studio-3t-linux-x64.sh
    fi
  fi
}