#!/usr/bin/env bash

installDBeaver() {
  echo "\n\n\n  Install DBeaver"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar DBeaver? [y/N]"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> sudo wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz -P ~/Downloads | bash\n"
      sudo wget https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz -P ~/Downloads | bash

      echo "\n> tar zxvf ~/Downloads/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz -C /opt\n"
      tar zxvf ~/Downloads/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz -C /opt

      echo "\n> sudo ln -sf /opt/dbeaver /usr/bin/dbeaver"
      sudo ln -sf /opt/dbeaver /usr/bin/dbeaver

      echo "\n> chmod a+x -R /opt/dbeaver\n"
      sudo chmod a+x -R /opt/dbeaver

      echo "\n> cp assets/dbeaver.svg /opt/dbeaver\n"
      cp assets/dbeaver.svg /opt/dbeaver

      echo "\n> sudo touch /usr/share/applications/dbeaver.desktop\n"
      sudo touch /usr/share/applications/dbeaver.desktop

      sudo echo "
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Name=DBeaver
      GenericName=SQL Database Client
      Comment=Universal Database Manager and SQL Client.
      Path=/usr/share/dbeaver/
      Exec=/usr/share/dbeaver/dbeaver
      Icon=/usr/share/dbeaver/dbeaver.svg
      Categories=IDE;Development;Application;
      WM_CLASS=DBeaver
      StartupWMClass=DBeaver
      StartupNotify=true
      " > /usr/share/applications/dbeaver.desktop
    fi
  fi
}