#!/usr/bin/env bash

installPycharm() {
  echo "\n\n\n  Install PyCharm"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar PyCharm? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> snap install pycharm-community --classic\n"
      snap install pycharm-community --classic

      echo "\n> sudo ln -sf /snap/pycharm-community/current /usr/bin/pycharm-community"
      sudo ln -sf /snap/pycharm-community/current /usr/bin/pycharm-community

      echo "\n> chmod a+x -R /opt/pycharmIC\n"
      sudo chmod a+x -R /opt/pycharmIC

      echo "\n> cp assets/pycharm.svg /opt/pycharmIC\n"
      cp assets/pycharm.svg /opt/pycharmIC

      echo "\n> sudo touch /usr/share/applications/pycharm-community.desktop\n"
      sudo touch /usr/share/applications/pycharm-community.desktop

      sudo echo "
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Name=Pycharm Community
      Exec=/pycharmIC/bin/pycharm.sh
      Icon=/pycharmIC/pycharm.svg
      Categories=Application;
      " > /usr/share/applications/pycharm-community.desktop
    fi
  fi
}