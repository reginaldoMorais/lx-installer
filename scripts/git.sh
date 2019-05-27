#!/bin/sh

installGit() {
  echo "\n\n\n  Install Git"
  echo "++++++++++++++++++++++\n"
  echo "> Deseja instalar Git? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo apt-get install git\n"
      sudo apt-get install git
    fi
  fi
}
