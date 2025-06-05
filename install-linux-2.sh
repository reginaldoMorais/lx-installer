#!/bin/bash

# Script de instalação de aplicativos para Linux (Ubuntu based)
# Aplicativos: VSCode, DBeaver, MongoDB Compass, Slack, Postman, JetBrains Toolbox, HydraPaper, Google Chrome, Docker, Oh My Zsh, Guake
# Ambientes de desenvolvimento: NVM, SDKman, Golang, pyenv

# Função para perguntar antes de instalar
ask_to_install() {
    echo -e "\n====================================================="
    echo -e "Deseja instalar $1? (S/n, padrão: S)"
    read -r response
    response=${response:-S}  # Define S como padrão se resposta for vazia
    if [[ "$response" =~ ^[Ss]$ ]]; then
        return 0  # True, instalar
    else
        echo -e "Pulando instalação de $1...\n"
        return 1  # False, não instalar
    fi
}

echo -e "====================================================="
echo -e "Iniciando instalação de aplicativos para Zorin OS"
echo -e "====================================================="

# Atualiza os repositórios - essencial
echo -e "Atualizando repositórios...\n"
sudo apt update

# Instalação do Git (primeiro pré-requisito) - essencial
echo -e "\n====================================================="
echo -e "Instalando dependências necessárias (obrigatório)...\n"
sudo apt install -y wget curl apt-transport-https gnupg software-properties-common build-essential libssl-dev zlib1g-dev libbz2-dev libxml2-dev libxmlsec1-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-pip python3-venv unzip ca-certificates zsh

# Instalação do Git (primeiro pré-requisito) - essencial
echo -e "\n====================================================="
echo -e "Instalando Git (obrigatório)...\n"
sudo apt install -y git
git --version
echo -e "Git instalado com sucesso!"

# Instalação do Guake Terminal
if ask_to_install "Guake Terminal"; then
    echo -e "====================================================="
    echo -e "Instalando Guake Terminal...\n"
    sudo apt install -y guake
    
    # Configurar Guake para iniciar com o sistema
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/guake.desktop << EOL
[Desktop Entry]
Type=Application
Name=Guake Terminal
Exec=guake
Comment=Drop-down terminal
Icon=guake
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOL

    # Configurações adicionais do Guake
    if [ -f ~/.zshrc ]; then
        # Define zsh como shell padrão para Guake se oh-my-zsh estiver instalado
        guake -r "zsh" &>/dev/null || true
    fi
    
    echo -e "Guake Terminal instalado com sucesso!"
    echo -e "Guake foi configurado para iniciar automaticamente com o sistema."
    echo -e "Para iniciar o Guake imediatamente, execute: guake"
    echo -e "Para abrir as preferências do Guake, execute: guake -p"
fi

# Instalação do Oh My Zsh
if ask_to_install "Oh My Zsh"; then
    echo -e "====================================================="
    echo -e "Instalando Oh My Zsh...\n"
    
    # Instalação do ZSH se ainda não estiver instalado
    if ! command -v zsh &> /dev/null; then
        sudo apt install -y zsh
    fi
    
    # Instalação do Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Instalação do fzf (fuzzy finder)
    echo -e "Instalando fzf...\n"
    sudo apt install -y fzf
    
    # Criação de um diretório temporário para plugins
    mkdir -p ~/zsh_plugins_temp
    cd ~/zsh_plugins_temp
    
    # Instalação dos plugins solicitados
    echo -e "Instalando plugins para Oh My Zsh...\n"
    
    # Plugin zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    # Plugin zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    # Plugin zsh-navigation-tools
    # Já incluído no Oh My Zsh, só precisa ser ativado
    
    # Plugin copybuffer
    # Já incluído no Oh My Zsh, só precisa ser ativado
    
    # Plugin dirhistory
    # Já incluído no Oh My Zsh, só precisa ser ativado
    
    # Plugin zsh-reload
    # Já incluído no Oh My Zsh, só precisa ser ativado
    
    # Plugin fzf para Oh My Zsh
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
    
    # Instalação do tema Powerlevel10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    
    # Limpa o diretório temporário
    cd ~
    rm -rf ~/zsh_plugins_temp
    
    # Configura o arquivo .zshrc para usar todos os plugins
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-navigation-tools copybuffer dirhistory fzf)/' ~/.zshrc
    
    # Configura o tema Powerlevel10k
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    
    # Adiciona algumas configurações úteis ao .zshrc
    cat >> ~/.zshrc << 'EOL'

# Configurações adicionais
export TERM="xterm-256color"
export EDITOR="nano"

# Configurações Powerlevel10k
# Para customizar o prompt, execute: p10k configure
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Ativar complementação sensível a maiúsculas/minúsculas
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Histórico melhorado
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Para ativar as ferramentas de navegação do ZSH, pressione Ctrl+Z
EOL
    
    echo -e "Oh My Zsh instalado com sucesso com todos os plugins solicitados!"
    echo -e "Para usar o ZSH como shell padrão, execute: chsh -s $(which zsh)"
    echo -e "Para configurar o tema Powerlevel10k, execute: p10k configure"
fi

# Instalação do HTOP
if ask_to_install "HTOP"; then
    echo -e "====================================================="
    echo -e "Instalando HTOP...\n"
    sudo apt update
    sudo apt install -y htop
    echo -e "HTOP instalado com sucesso!"
fi

# Instalação do Docker
if ask_to_install "Docker"; then
    echo -e "====================================================="
    echo -e "Instalando Docker...\n"
    # Remover versões antigas, se existirem
    sudo apt remove docker docker-engine docker.io containerd runc || true

    # Configurar o repositório do Docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo -e "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Atualizar o repositório
    sudo apt update

    # Instalar o Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Configurar o usuário para usar o Docker sem sudo
    # sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker

    # Iniciar o serviço do Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    echo -e "Docker instalado com sucesso!"
    echo -e "Para usar o Docker sem sudo, reinicie o sistema ou execute: newgrp docker"

    echo -e "====================================================="
    echo -e "Instalando Docker ctop...\n"
    
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop
    
    echo -e "Docker ctop instalado com sucesso!"
fi

# Instalação do Google Chrome
if ask_to_install "Google Chrome"; then
    echo -e "====================================================="
    echo -e "Instalando Google Chrome...\n"
    
    # Importa a chave de assinatura do Google
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    
    # Verifica se o arquivo de lista do repositório já existe
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
        # Cria o arquivo apenas se não existir
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
        echo -e "Repositório do Google Chrome adicionado."
    else
        echo -e "Repositório do Google Chrome já existe. Mantendo configuração atual."
    fi
    
    # Atualiza os repositórios e instala o Chrome
    sudo apt update
    sudo apt install -y google-chrome-stable
    echo -e "Google Chrome instalado com sucesso!"
fi

# Instalação do Visual Studio Code
if ask_to_install "Visual Studio Code"; then
    echo -e "====================================================="
    echo -e "Instalando Visual Studio Code...\n"
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code
    echo -e "Visual Studio Code instalado com sucesso!"
fi

# Instalação do DBeaver
if ask_to_install "DBeaver"; then
    echo -e "====================================================="
    echo -e "Instalando DBeaver...\n"
    wget -O dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -i dbeaver.deb
    sudo apt install -f -y
    rm dbeaver.deb
    echo -e "DBeaver instalado com sucesso!"
fi

# Instalação do MongoDB Compass
if ask_to_install "MongoDB Compass"; then
    echo -e "====================================================="
    echo -e "Instalando MongoDB Compass...\n"
    wget -qO- https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
    wget https://downloads.mongodb.com/compass/mongodb-compass_1.40.4_amd64.deb
    sudo dpkg -i mongodb-compass_1.40.4_amd64.deb
    sudo apt install -f -y
    rm mongodb-compass_1.40.4_amd64.deb
    echo -e "MongoDB Compass instalado com sucesso!"
fi

# Instalação do Slack
if ask_to_install "Slack"; then
    echo -e "====================================================="
    echo -e "Instalando Slack...\n"
    wget https://downloads.slack-edge.com/releases/linux/4.35.126/prod/x64/slack-desktop-4.35.126-amd64.deb
    sudo dpkg -i slack-desktop-4.35.126-amd64.deb
    sudo apt install -f -y
    rm slack-desktop-4.35.126-amd64.deb
    echo -e "Slack instalado com sucesso!"
fi

# Instalação do Postman
if ask_to_install "Postman"; then
    echo -e "====================================================="
    echo -e "Instalando Postman...\n"
    wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
    sudo tar -xzf postman.tar.gz -C /opt
    sudo ln -s /opt/Postman/Postman /usr/bin/postman
    cat > ~/.local/share/applications/postman.desktop << EOL
[Desktop Entry]
Type=Application
Name=Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Exec=/opt/Postman/Postman
Comment=Postman API Client
Categories=Development;
EOL
    rm postman.tar.gz
    echo -e "Postman instalado com sucesso!"
fi

# Instalação do JetBrains Toolbox
if ask_to_install "JetBrains Toolbox"; then
    echo -e "====================================================="
    echo -e "Instalando JetBrains Toolbox...\n"
    wget -cO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
    sudo tar -xzf jetbrains-toolbox.tar.gz -C /opt
    # Encontra o diretório extraído
    TOOLBOX_DIR=$(find /opt -name "jetbrains-toolbox-*" -type d | head -n 1)
    # Cria link simbólico
    sudo ln -s "$TOOLBOX_DIR/jetbrains-toolbox" /usr/bin/jetbrains-toolbox
    cat > ~/.local/share/applications/jetbrains-toolbox.desktop << EOL
[Desktop Entry]
Type=Application
Name=JetBrains Toolbox
Icon=$TOOLBOX_DIR/jetbrains-toolbox.svg
Exec=jetbrains-toolbox
Comment=JetBrains Toolbox
Categories=Development;
EOL
    rm jetbrains-toolbox.tar.gz
    echo -e "JetBrains Toolbox instalado com sucesso!"
fi

# Instalação do HydraPaper
if ask_to_install "HydraPaper"; then
    echo -e "====================================================="
    echo -e "Instalando HydraPaper...\n"
    # Instala dependências do flatpak se não estiver instalado
    if ! command -v flatpak &> /dev/null; then
        echo -e "Instalando Flatpak...\n"
        sudo apt install -y flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    # Instala o HydraPaper via Flatpak
    flatpak install -y flathub org.gabmus.hydrapaper

    echo -e "HydraPaper instalado com sucesso via Flatpak!"
    echo -e "Você pode iniciá-lo pelo menu de aplicativos ou pelo comando: flatpak run org.gabmus.hydrapaper"
fi

# Instalação do NVM (Node Version Manager)
if ask_to_install "NVM (Node Version Manager)"; then
    echo -e "====================================================="
    echo -e "Instalando NVM (Node Version Manager)...\n"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Configurando NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Carrega o NVM
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Carrega auto-complete do NVM

    # Instala a versão LTS do Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node

    echo -e "NVM e Node.js LTS instalados com sucesso!"
    echo -e "Lembre-se de reiniciar seu terminal ou executar source ~/.bashrc para usar o NVM."
    
    # Adiciona configurações NVM ao .zshrc se Oh My Zsh estiver instalado
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOL'

# NVM - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOL
    fi
fi

# Instalação do SDKMAN
if ask_to_install "SDKMAN (Java Version Manager)"; then
    echo -e "====================================================="
    echo -e "Instalando SDKMAN...\n"
    curl -s "https://get.sdkman.io" | bash

    # Configurando SDKMAN
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Instala Java mais recente
    sdk install java

    echo -e "SDKMAN instalado com sucesso!"
    echo -e "Lembre-se de reiniciar seu terminal ou executar source ~/.bashrc para usar o SDKMAN."
    
    # Adiciona inicialização do SDKMAN ao .zshrc se Oh My Zsh estiver instalado
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOL'

# SDKMAN - Java Version Manager
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOL
    fi
fi

# Instalação do Go (Golang)
if ask_to_install "Golang"; then
    echo -e "====================================================="
    echo -e "Instalando Golang...\n"
    GOLANG_VERSION="1.21.3"  # Ajuste para a versão mais recente se necessário
    wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz
    rm go${GOLANG_VERSION}.linux-amd64.tar.gz

    # Adiciona Go ao PATH no .bashrc
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
    export PATH=$PATH:/usr/local/go/bin
    export PATH=$PATH:$HOME/go/bin
    
    # Adiciona Go ao PATH no .zshrc se Oh My Zsh estiver instalado
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOL'

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
EOL
    fi

    echo -e "Golang ${GOLANG_VERSION} instalado com sucesso!"
fi

# Instalação do pyenv
if ask_to_install "pyenv (Python Version Manager)"; then
    echo -e "====================================================="
    echo -e "Instalando pyenv...\n"
    curl https://pyenv.run | bash

    # Configurando pyenv no .bashrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

    # Configurando pyenv no .zshrc se Oh My Zsh estiver instalado
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOL'

# pyenv - Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOL
    fi

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    # Instala a versão mais recente do Python
    pyenv install 3.11.6
    pyenv global 3.11.6

    echo -e "pyenv instalado com sucesso!"
    echo -e "Lembre-se de reiniciar seu terminal ou executar source ~/.bashrc para usar o pyenv."
fi

# Instalação do Ruby (Ruby on Rails)
if ask_to_install "Ruby"; then
    echo -e "====================================================="
    echo -e "Instalando Mise manager para Ruby...\n"

    sudo apt install build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev
    curl https://mise.run | sh

    echo -e '\n\neval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
    # Adiciona Go ao PATH no .zshrc se Oh My Zsh estiver instalado
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOL'

# Mise
eval "$(~/.local/bin/mise activate bash)"
EOL
    fi
    source ~/.bashrc
    source ~/.zshrc

    echo -e "\nInstalando Ruby...\n"
    mise use -g ruby@3

    source ~/.bashrc
    source ~/.zshrc

    ruby --version
    
    echo -e "\nInstalando Rails...\n"
    gem install rails
    rails --version

    echo -e "\nRuby and Rails instalado com sucesso!"
fi

echo -e "====================================================="
echo -e "Instalação finalizada!"
echo -e "Para que todas as ferramentas funcionem corretamente, execute:"
echo -e "source ~/.bashrc"
if [ -f ~/.zshrc ]; then
    echo -e "Para ativar o Oh My Zsh, execute: zsh"
    echo -e "Para tornar o zsh seu shell padrão, execute: chsh -s $(which zsh)"
    echo -e "Para configurar o tema Powerlevel10k, execute: p10k configure"
fi
echo -e "Para iniciar o Guake Terminal, execute: guake"
echo -e "====================================================="