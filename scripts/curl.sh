#!/bin/sh

installCurl() {
  echo "\n\n\n  Install Curl"
  echo "++++++++++++++++++++++"
  echo "\n> Deseja instalar Curl? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo apt install curl\n"
      sudo apt-get install curl
    fi
  fi
}
