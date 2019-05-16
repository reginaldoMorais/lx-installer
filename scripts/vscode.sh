#!/usr/bin/env bash

installVsCode() {
  echo "\n\n\n  Install VsCode"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar VsCode? [y/N]\n"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -Copy\n"
      wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -Copy

      echo "\n> sudo add-apt-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main'\n"
      sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

      echo "\n> sudo apt update\n"
      sudo apt update

      echo "\n> sudo apt install code\n"
      sudo apt install code
    fi
  fi
}
