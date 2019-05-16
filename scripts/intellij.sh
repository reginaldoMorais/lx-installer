#!/usr/bin/env bash

installIntellj() {
  echo "\n\n\n  Install Intellj"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Intellj? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> wget http://ppa.launchpad.net/ubuntuhandbook1/apps/ubuntu/pool/main/i/intellij-idea-community/intellij-idea-community_2017.3.2-1_all.deb -O ~/Downloads/intellij-idea-community_2017.3.2.deb\n"
      wget http://ppa.launchpad.net/ubuntuhandbook1/apps/ubuntu/pool/main/i/intellij-idea-community/intellij-idea-community_2017.3.2-1_all.deb -O ~/Downloads/intellij-idea-community_2017.3.2.deb

      echo "\n> sudo dpkg -i ~/Downloads/intellij-idea-community_2017.3.2.deb\n"
      sudo dpkg -i ~/Downloads/intellij-idea-community_2017.3.2.deb

      echo "\n> chmod a+x -R /opt/ideaIC\n"
      sudo chmod a+x -R /opt/ideaIC

      echo "\n> cp assets/idea.svg /opt/ideaIC\n"
      cp assets/idea.svg /opt/ideaIC

      echo "\n> sudo touch /usr/share/applications/intellij-idea-community.desktop\n"
      sudo touch /usr/share/applications/intellij-idea-community.desktop

      sudo echo "
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Name=Intellij Idea Community
      Exec=/opt/ideaIC/bin/idea.sh
      Icon=/opt/ideaIC/idea.svg
      Categories=Application;
      " > /usr/share/applications/intellij-idea-community.desktop
    fi
  fi
}