#!/usr/bin/env bash

installPostman() {
  echo "\n\n\n  Install Postman"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar Postman? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget https://dl.pstmn.io/download/latest/linux64 -O ~/Downloads/postman.tar.gz | bash\n"
      sudo wget https://dl.pstmn.io/download/latest/linux64 -O ~/Downloads/postman.tar.gz | bash

      echo "\n> sudo tar -xzf ~/Downloads/postman.tar.gz -C /opt\n"
      sudo tar -xzf ~/Downloads/postman.tar.gz -C /opt

      echo "\n> sudo ln -sf /opt/postman /usr/bin/Postman"
      sudo ln -sf /opt/Postman /usr/bin/Postman

      echo "\n> chmod a+x -R /opt/postman\n"
      sudo chmod a+x -R /opt/postman

      echo "\n> cp assets/postman.svg /opt/postman\n"
      cp assets/postman.svg /opt/postman

      echo "\n> sudo touch /usr/share/applications/postman.desktop\n"
      sudo touch /usr/share/applications/postman.desktop

      sudo echo "
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Name=Postman
      Exec=/opt/postman/app/Postman
      Icon=/opt/postman/postman.svg
      Categories=IDE;Development;Application;
      " > /usr/share/applications/postman.desktop
    fi
  fi
}