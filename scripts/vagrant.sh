#!/bin/sh

installVagrant() {
  echo "\n\n\n  Install Vagrant"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Vagrant? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo apt-get install vagrant\n"
      sudo apt-get install vagrant
    fi
  fi
}
