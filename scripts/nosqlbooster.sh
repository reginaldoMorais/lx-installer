#!/bin/sh

installNoSqlBooster() {
  echo "\n\n\n  Install NoSqlBooster"
  echo "++++++++++++++++++++++"

  echo "\n> Deseja instalar NoSqlBooster? [y/N]\n"
  read question

  if [ ! -z $question ]
  then
    if [ "y" = $question -o "Y" = $question ]
    then
      echo "\n> wget https://nosqlbooster.com/s3/download/releasesv5/nosqlbooster4mongo-5.1.7.AppImage -O ~/Downlaods/nosqlbooster4mongo.AppImage\n"
      wget https://nosqlbooster.com/s3/download/releasesv5/nosqlbooster4mongo-5.1.7.AppImage -O ~/Downlaods/nosqlbooster4mongo.AppImage

      echo "\n> sudo chmod a+x nosqlbooster4mongo.AppImage\n"
      sudo sudo chmod a+x ~/Downlaods/nosqlbooster4mongo.AppImage

      echo "\n> cp ~/Downlaods/nosqlbooster4mongo.AppImage /opt/nosqlbooster\n"
      cp ~/Downlaods/nosqlbooster4mongo.AppImage /opt/nosqlbooster

      echo "\n> cp assets/nosqlbooster.svg /opt/nosqlbooster\n"
      cp assets/nosqlbooster.svg /opt/nosqlbooster

      echo "\n> sudo touch /usr/share/applications/nosqlbooster.desktop\n"
      sudo touch /usr/share/applications/nosqlbooster.desktop

      sudo echo "
      [Desktop Entry]
      Version=1.0
      Type=Application
      Terminal=false
      Name=No SQL Booster
      Exec=./opt/nosqlbooster/nosqlbooster4mongo.AppImage
      Icon=/opt/nosqlbooster/nosqlbooster.svg
      Categories=IDE;Development;Application;
      " > /usr/share/applications/nosqlbooster.desktop
    fi
  fi
}
