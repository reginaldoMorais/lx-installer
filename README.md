# Linux Apps Installer

Script de pré-instalação de aplicativos em Linux com base Debian/Ubuntu

## Summary

- [Linux Apps Installer](#linux-apps-installer)
  - [Summary](#summary)
  - [To install apps](#to-install-apps)
  - [New installation](#new-installation)
  - [Legacy installation](#legacy-installation)

## To install apps

## New installation

Para rodar o script execute:

```bash
cd lx-installer/
sudo ./install-linux-2.sh
```

Será possível escolher quais itens instalar.

- Configurações:
  - Command Extensions
  - Fonts
  - Git Alias
  - SSL Keys
  - Vscode Settings
  - Guake Terminal Settings
- Aplicativos:
  - VSCode
  - DBeaver
  - MongoDB Compass
  - Slack
  - Postman
  - JetBrains Toolbox
  - HydraPaper
  - Google Chrome
  - Docker
  - Oh My Zsh
  - Guake Terminal
- Ambientes de desenvolvimento:
  - NVM e NodeJS
  - SDKman e Java com Gradle
  - Golang
  - pyenv e Python
  - Mise e Ruby com Rails

## Legacy installation

Para rodar o script execute:

```bash
cd lx-installer/
sudo ./install-linux.sh
```

Aparecerá um menu com as opções de softwares.
