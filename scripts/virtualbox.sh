#!/bin/sh

installVirtualBox() {
  echo "\n\n\n  Install VirtalBox"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar VirtualBox? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo apt-get install virtualbox\n"
      sudo apt-get install virtualbox
    fi
  fi
}
