#!/usr/bin/env bash

installDocker() {
  echo "\n\n\n  Install Docker"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Docker? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo apt-get remove docker docker-engine docker.io\n"
      sudo apt-get remove docker docker-engine docker.io

      echo "\n> sudo apt-get install apt-transport-https ca-certificates gnupg2 software-properties-common python-software-properties\n"
      sudo apt-get install apt-transport-https ca-certificates gnupg2 software-properties-common python-software-properties

      echo "\n> sudo apt-key fingerprint 0EBFCD88\n"
      sudo apt-key fingerprint 0EBFCD88

      echo "\n> curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -\n"
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

      echo "\n> sudo add-apt-repository `deb [arch=amd64] https://download.docker.com/linux/debian wheezy stable`\n"
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian wheezy stable"

      echo "\n> sudo apt-get update\n"
      sudo apt-get update

      echo "\n> sudo apt-get install docker-ce\n"
      sudo apt-get install docker-ce
    fi
  fi
}

installKitmatic() {
  echo "\n\n\n  Install Kitmatic"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Kitmatic? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget https://github.com/docker/kitematic/releases/download/v0.17.6/Kitematic-0.17.6-Ubuntu.zip -O ~/Downloads/Kitematic.zip | bash\n"
      sudo wget https://github.com/docker/kitematic/releases/download/v0.17.6/Kitematic-0.17.6-Ubuntu.zip -O ~/Downloads/Kitematic.zip | bash

      echo "\n> sudo unzip ~/Downloads/Kitematic.zip -d ~/Downloads\n"
      sudo unzip ~/Downloads/Kitematic.zip -d ~/Downloads

      echo "\n> dpkg -i ~/Downloads/Kitematic-0.17.6_amd64.deb\n"
      dpkg -i ~/Downloads/Kitematic-0.17.6_amd64.deb
    fi
  fi
}