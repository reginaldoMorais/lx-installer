#!/bin/sh

. ./scripts/apt.sh
. ./scripts/curl.sh
. ./scripts/git.sh
. ./scripts/nvm.sh
. ./scripts/sdkman.sh
. ./scripts/postman.sh
. ./scripts/vscode.sh
. ./scripts/franz.sh
. ./scripts/dbeaver.sh
. ./scripts/virtualbox.sh
. ./scripts/vagrant.sh
. ./scripts/docker.sh
. ./scripts/studio3t.sh
. ./scripts/nosqlbooster.sh

# Rever
. ./scripts/intellij.sh
. ./scripts/pycharm.sh

MainMenu() {
  x="teste"

  while true $x != "teste"
  do
    clear
    echo "\n\e[34m===============================================\e[0m"
    echo "\e[34m             Linux Apps Installer\e[0m"
    echo "\e[34m               Reginaldo Morais\e[0m"
    echo "\e[34m===============================================\e[0m"
    echo "\e[34m                  Main Menu\e[0m"
    echo "\n\e[32m1) Install Essential Apps\e[0m"
    echo "\e[31m   Curl | Git | VirtualBox\e[0m"
    echo "\e[32m2) Install Dev Apps\e[0m"
    echo "\e[31m   SDKman | NVM | Docker and Kitmatic | Vagrant | Postman\e[0m"
    echo "\e[32m3) Install IDEs\e[0m"
    echo "\e[31m   VsCode | Intellij | PyCharm\e[0m"
    echo "\e[32m4) Install DB Access Apps\e[0m"
    echo "\e[31m   Studio3T | NoSqlBooster | DBeaver\e[0m"
    echo "\e[32m5) Install Messagers\e[0m"
    echo "\e[31m   Franz\e[0m"
    echo "\e[32m6) Install one by one \e[0m"
    echo "\e[32m7) Close Installer\e[0m"
    echo "\n\e[34m===============================================\e[0m"

    read -p "Select one option: " x
    echo "\nOption selected ($x)"

    case "$x" in 
    
    1)
      # SISTEMA
      aptGetUpdate
      installCurl
      installGit
      installVirtualBox
      echo "\nReturn to menu..."
      sleep 2
    ;;

    2)
      # DEV
      aptGetUpdate
      installSdkman
      installNVM
      installDocker
      installKitmatic
      installVagrant
      installPostman
      echo "\nReturn to menu..."
      sleep 2
    ;;

    3)
      # IDE
      aptGetUpdate
      installVsCode
      installIntellj
      installPycharm
      echo "\nReturn to menu..."
      sleep 2
    ;;

    4)
      # DB
      aptGetUpdate
      installStudio3T
      installNoSqlBooster
      installDBeaver
      echo "\nReturn to menu..."
      sleep 2
    ;;

    5)
      # MESSAGER
      aptGetUpdate
      installFranz
      echo "\nReturn to menu..."
      sleep 2
    ;;

    6)
      SubMenu
    ;;

    7)
      aptGetUpdate
      echo "\nClosing Installer..."
      sleep 1
      clear;
      exit;
      echo \n\n"==============================================="
      echo "         Linux Apps Installer Done!"
      echo "===============================================\n"
    ;;

    *)
        echo "Opção inválida!"
    ;;
  esac
  done
}

SubMenu() {
  x="teste"

  while true $x != "teste"
  do
    clear
        echo "\n\e[34m===============================================\e[0m"
    echo "\e[34m             Linux Apps Installer\e[0m"
    echo "\e[34m               Reginaldo Morais\e[0m"
    echo "\e[34m===============================================\e[0m"
    echo "\e[34m               One by One Menu\e[0m"
    echo "\n\e[32m1) Install cURL\e[0m"
    echo "\e[32m2) Install Git\e[0m"
    echo "\e[32m3) Install VirtualBox\e[0m"
    echo "\e[32m4) Install SDKman\e[0m"
    echo "\e[32m5) Install NVM\e[0m"
    echo "\e[32m6) Install Docker and Kitmatic\e[0m"
    echo "\e[32m7) Install Vagrant\e[0m"
    echo "\e[32m8) Install Postman\e[0m"
    echo "\e[32m9) Install VsCode\e[0m"
    echo "\e[32m10) Install Intellij\e[0m"
    echo "\e[32m11) Install PyCharm\e[0m"
    echo "\e[32m12) Install Studio3T\e[0m"
    echo "\e[32m13) Install NoSqlBooster\e[0m"
    echo "\e[32m14) Install DBeaver\e[0m"
    echo "\e[32m15) Install Franz\e[0m"
    echo "\e[32m16) Return to main menu\e[0m"
    echo "\e[34m===============================================\e[0m"

    read -p "Select one option: " x
    echo "\nOption selected ($x)"

    case "$x" in 
    
    1)
      # CURL
      aptGetUpdate
      installCurl
      echo "\nReturn to menu..."
      sleep 2
    ;;

    2)
      # CURL
      aptGetUpdate
      installGit
      echo "\nReturn to menu..."
      sleep 2
    ;;

    3)
      # VIRTUALBOX
      aptGetUpdate
      installVirtualBox
      echo "\nReturn to menu..."
      sleep 2
    ;;

    4)
      # SDKMAN
      aptGetUpdate
      installSdkman
      echo "\nReturn to menu..."
      sleep 2
    ;;

    5)
      # NVM
      aptGetUpdate
      installNVM
      echo "\nReturn to menu..."
      sleep 2
    ;;

    6)
      # DOCKER
      aptGetUpdate
      installDocker
      echo "\nReturn to menu..."
      sleep 2
    ;;

    7)
      # VAGRANT
      aptGetUpdate
      installVagrant
      echo "\nReturn to menu..."
      sleep 2
    ;;

    8)
      # POSTMAN
      aptGetUpdate
      installPostman
      echo "\nReturn to menu..."
      sleep 2
    ;;

    9)
      # VSCODE
      aptGetUpdate
      installVsCode
      echo "\nReturn to menu..."
      sleep 2
    ;;

    10)
      # INTELLIJ
      aptGetUpdate
      installIntellj
      echo "\nReturn to menu..."
      sleep 2
    ;;

    11)
      # PYCHARM
      aptGetUpdate
      installPycharm
      echo "\nReturn to menu..."
      sleep 2
    ;;

    12)
      # STUDIO3T
      aptGetUpdate
      installStudio3T
      echo "\nReturn to menu..."
      sleep 2
    ;;

    13)
      # NOSQLBOOSTER
      aptGetUpdate
      installNoSqlBooster
      echo "\nReturn to menu..."
      sleep 2
    ;;

    14)
      # DEBEAVER
      aptGetUpdate
      installDBeaver
      echo "\nReturn to menu..."
      sleep 2
    ;;

    15)
      # FRANZ
      aptGetUpdate
      installFranz
      echo "\nReturn to menu..."
      sleep 2
    ;;

    16)
      MainMenu
    ;;

    *)
        echo "Opção inválida!"
    ;;
  esac
  done
}

MainMenu
