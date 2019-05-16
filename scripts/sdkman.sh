#!/bin/sh

installSdkman() {
  echo "\n\n\n  Install Sdkman"
  echo "++++++++++++++++++++++"
  echo "\n> Deseja instalar Sdkman? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo curl -s "https://get.sdkman.io" | bash\n"
      sudo curl -s "https://get.sdkman.io" | bash

      echo "\n> source '~/.sdkman/bin/sdkman-init.sh'\n"
      source "~/.sdkman/bin/sdkman-init.sh"

      echo "\n> source ~/.bashrc\n"
      source ~/.bashrc

      echo "\n> sdk update\n"
      sdk update

      echo "\n> sdk version\n"
      sdk version

      echo "\n> sdk i java 8.0.191-oracle\n"
      sdk i java 8.0.191-oracle

      echo "\n> sdk i gradle\n"
      sdk i gradle

      echo "\n> sdk i groovy\n"
      sdk i groovy

      echo "\n> sdk i grails\n"
      sdk i grails
    fi
  fi
}
