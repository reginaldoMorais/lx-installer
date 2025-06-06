#!/bin/bash

# Script de instalação de aplicativos para Zorin OS ou Ubuntu
# Configurações: Command Extensions, Fonts, Git Alias, SSL Keys, Vscode Settings, Guake Terminal Settings
# Aplicativos: VSCode, DBeaver, MongoDB Compass, Slack, Postman, JetBrains Toolbox, HydraPaper, Google Chrome, Docker, Oh My Zsh, Guake Terminal
# Ambientes de desenvolvimento: NVM e NodeJS, SDKman e Java com Gradle, Golang, pyenv e Python, Mise e Ruby com Rails

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

# Função para criar atalho customizado
create_custom_shortcut() {
    local name="$1"
    local command="$2"
    local binding="$3"
    
    # Obter lista atual de atalhos customizados
    local custom_keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
    
    # Encontrar próximo slot disponível
    local index=0
    while [[ $custom_keybindings == *"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$index/"* ]]; do
        ((index++))
    done
    
    local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$index/"
    
    # Configurar o novo atalho
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$path binding "$binding"
    
    # Adicionar à lista de atalhos customizados
    if [[ $custom_keybindings == "[]" ]] || [[ $custom_keybindings == "@as []" ]]; then
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$path']"
    else
        # Remove os colchetes e adiciona o novo path
        custom_keybindings=${custom_keybindings%]*}
        custom_keybindings="${custom_keybindings}, '$path']"
        gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$custom_keybindings"
    fi
    
    echo -e "Atalho criado: $binding -> $command"
}

echo -e "====================================================="
echo -e "Iniciando instalação de aplicativos para Zorin OS"
echo -e "====================================================="

if [ ! -d "/home/reginaldomorais/Workspaces" ]; then
	echo -e "Criando Workspaces...\n"
    mkdir -p /home/reginaldomorais/Workspaces
fi

if [ ! -d "/home/reginaldomorais/Workspaces/my" ]; then
	echo -e "Criando Workspaces My...\n"
    mkdir -p /home/reginaldomorais/Workspaces/my
fi

# Atualiza os repositórios - essencial
echo -e "Atualizando repositórios...\n"
sudo apt update

# Instalação do Git (primeiro pré-requisito) - essencial
echo -e "\n====================================================="
echo -e "Instalando dependências necessárias (obrigatório)...\n"
sudo apt install -y wget curl apt-transport-https gnupg software-properties-common build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libxml2-dev libxmlsec1-dev python3-pip python3-venv unzip ca-certificates zsh

# Instalação do Git (primeiro pré-requisito) - essencial
echo -e "\n====================================================="
echo -e "Instalando Git (obrigatório)...\n"
sudo apt install -y git
git --version
echo -e "Git instalado com sucesso!"

# Instalação da Fira Code Nerd Font
if ask_to_install "Fira Code Nerd Font"; then
    echo -e "====================================================="
    echo -e "Instalando Fira Code Nerd Font...\n"
    
    # Configurações
    FONT_NAME="FiraCode"
    DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    TEMP_DIR="/tmp/firacode-install"
    FONT_DIR="$HOME/.local/share/fonts"
    ZIP_FILE="$TEMP_DIR/FiraCode.zip"

    # Verificar dependências
    if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
        echo "Erro: wget ou curl não encontrados. Instale um deles para continuar."
        exit 1
    fi

    if ! command -v unzip >/dev/null 2>&1; then
        echo "Erro: unzip não encontrado. Instale o pacote unzip para continuar."
        exit 1
    fi

    # Criar diretórios
    mkdir -p "$TEMP_DIR"
    mkdir -p "$FONT_DIR"

    # Baixar a fonte
    echo "Baixando Fira Code Nerd Font..."
    if command -v wget >/dev/null 2>&1; then
        wget -O "$ZIP_FILE" "$DOWNLOAD_URL"
    else
        curl -L -o "$ZIP_FILE" "$DOWNLOAD_URL"
    fi

    # Verificar download
    if [ ! -f "$ZIP_FILE" ]; then
        echo "Erro: Falha ao baixar o arquivo."
        exit 1
    fi

    # Descompactar
    echo "Descompactando arquivo..."
    cd "$TEMP_DIR"
    unzip -q "$ZIP_FILE"

    # Copiar fontes
    echo "Copiando fontes para $FONT_DIR..."
    find "$TEMP_DIR" -name "*.ttf" -o -name "*.otf" | while read -r font_file; do
        cp "$font_file" "$FONT_DIR/"
        echo "Copiado: $(basename "$font_file")"
    done

    # Atualizar cache de fontes
    echo "Atualizando cache de fontes..."
    if command -v fc-cache >/dev/null 2>&1; then
        fc-cache -f -v "$FONT_DIR" >/dev/null 2>&1
        echo "Cache de fontes atualizado."
    else
        echo "Aviso: fc-cache não encontrado. Você pode precisar reiniciar para usar a fonte."
    fi

    # Limpeza
    echo "Limpando arquivos temporários..."
    rm -rf "$TEMP_DIR"

    # Verificar instalação
    if fc-list 2>/dev/null | grep -i "fira.*code.*nerd" >/dev/null 2>&1; then
        echo "Fira Code Nerd Font instalada com sucesso!"
    else
        echo "Fonte instalada. Reinicie aplicações para que apareça nas opções."
    fi
    
    echo -e "Para usar no terminal, configure 'FiraCode Nerd Font' nas preferências.\n"
fi

# Instalação do Git Alias
if ask_to_install "Git Alias"; then
    echo -e "====================================================="
    echo -e "Criando Git Alias...\n"

    cat > ~/.gitconfig << EOL
[alias]
  # Config user
  i = init

  # Clone repository
  cl = clone

  # Config user
  me = config user.name

  # Config email
  em = config user.email

  # Add file to stage
  a = add

  # Add all file to stage
  all = add .

  # Push main
  psu = push origin main -u

  # Push
  ps = push origin

  # Push
  pl = pull origin

  # Fetch
  fe = fetch

  # Commit
  ci = "!f() { git commit -m \"$*\"; }; f"

  # Checkout
  co = checkout

  # Checkout main
  cm = checkout main

  # Checkout develop
  cd = checkout develop

  # Checkout new branch
  cb = checkout -b

  # Remote
  rt = remote

  # Status
  s = status

  # Status
  ls = status

  # Less verbose status
  sb = status -sb

  # Stash
  st = stash

  # Stash pop
  sp = stash pop

  # Show last commit name
  sf = show --name-only

  # Pretty log
  lgo = log --graph --oneline

  # Pretty log
  lg = log --pretty=format:'%Cred%h%Creset %C(bold)%cr%Creset %Cgreen<%an>%Creset %s' --max-count=30

  # Remote commits ahead of mine
  incoming = !(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' ..@{u})

  # Remote commits ahead of local
  outgoing = !(git fetch --quiet && git log --pretty=format:'%C(yellow)%h %C(white)- %C(red)%an %C(white)- %C(cyan)%d%Creset %s %C(white)- %ar%Creset' @{u}..)

  # The missing command <3
  unstage = reset HEAD --

  # Undo modifications to a file
  undo = checkout --

  # Soft reset
  rollback = reset --soft HEAD~1

  # Last 24 hours commits
  standup = !(git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --since yesterday --author "$(git me)")

  # Review commits before pushing
  ready = rebase -i @{u}

  # Branchs hier
  hier = log --all --graph --decorate --oneline --simplify-by-decoration

  # List committers
  committers = !(git log | grep Author | sort | uniq -c | sort -n -r)

[user]
  name = Reginaldo Morais
  email = reginaldo.cmorais@gmail.com
EOL
    echo -e "Git Alias criado com sucesso!"
fi


# Instalação do SSL Keys
if ask_to_install "SSL Keys"; then
    echo -e "====================================================="
    echo -e "Criando SSL Keys...\n"

    ssh-keygen -t rsa -b 4096 -C "REGINALDO-LXZ-PCG"
    ssh-keygen -t ed25519 -C "REGINALDO-LXZ-PCG"
    cat > ~/.ssh/config << EOL
Host github-reginaldoMorais
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa

Host gitlab-reginaldoMorais
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_rsa

Host github-rmorais
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

Host gitlab-rmorais
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519
EOL
    cat ~/.ssh/config
    echo -e "SSL Keys criados com sucesso!"
fi

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

# Configuração do Guake para usar zsh
if ask_to_install "Guake com zsh"; then
    echo -e "====================================================="
    echo -e "Configurando Guake para usar zsh...\n"

    # Verificar se Guake está instalado
    if ! command -v guake &> /dev/null; then
        echo -e "Erro ao configurar Guake para usar zsh: Guake não está instalado no sistema."
        exit 1
    fi

    # Verificar se zsh está instalado
    if ! command -v zsh &> /dev/null; then
        echo -e "Erro ao configurar Guake para usar zsh: zsh não está instalado no sistema."
        exit 1
    fi

    # Obtém o caminho completo do zsh
    ZSH_PATH=$(which zsh)
    
    # Define o zsh como shell customizado no Guake
    gsettings set guake.general default-shell "$ZSH_PATH"
    gsettings set guake.general use-login-shell false
    gsettings set guake.general start-at-login true
    gsettings set guake.general window-losefocus true
    gsettings set guake.style.background transparency 90
    
    echo -e "- Shell configurado para: $ZSH_PATH"
    echo -e "- Outras configurações executadas"
    
    # Verifica se o Guake está rodando e reinicia se necessário
    if pgrep guake > /dev/null; then
        echo -e "\nReiniciando Guake para aplicar as mudanças..."
        pkill guake
        sleep 1
        nohup guake > /dev/null 2>&1 &
        disown
        echo -e "Guake reiniciado com sucesso!"
    else
        echo -e "\nInicie o Guake para ver as mudanças!"
    fi
    
    # Mostra as configurações atuais
    echo -e "\nConfigurações atuais do Guake:"
    echo -e "- Shell padrão: $(gsettings get guake.general default-shell)"
    echo -e "- Usar shell de login: $(gsettings get guake.general use-login-shell)"
    echo -e "- Carregar ao iniciar o sitema: $(gsettings get guake.general start-at-login)"
    echo -e "- Esconder ao perder o foco: $(gsettings get guake.general window-losefocus)"
    echo -e "- Background color em 90%: $(gsettings get guake.style.background transparency)"
    echo -e "\nGuake configurado com sucesso!"
fi

# Configurar atalho customizado para Guake
if ask_to_install "atalho customizado Alt+W para Guake"; then
    echo -e "====================================================="
    echo -e "Configurando atalho customizado para Guake...\n"
    
    # Verificar se já existe um atalho para Guake
    existing_shortcut=$(gsettings get org.guake.keybindings.global show-hide)
    echo -e "Atalho atual do Guake: $existing_shortcut"
    
    # Criar atalho customizado Alt+W
    create_custom_shortcut "Guake Terminal" "guake" "<Alt>w"
    
    echo -e "\nAtalho configurado com sucesso!"
    echo -e "Agora você pode usar Alt+W para abrir/fechar o Guake"
    echo -e "\nObservação: O Guake ainda manterá seu atalho padrão ($existing_shortcut)"
fi

# Configurar atalho customizado para Guake
if ask_to_install "atalho customizado Alt+X para xkill"; then
    echo -e "====================================================="
    echo -e "Configurando atalho customizado para xkill...\n"
    
    # Criar atalho customizado Alt+X
    create_custom_shortcut "Guake Terminal" "xkill" "<Alt>x"
    
    echo -e "\nAtalho configurado com sucesso!"
    echo -e "Agora você pode usar Alt+X para abrir/fechar o Guake"
fi

# Configurar atalho para fechar janela como Alt+Q
if ask_to_install "atalho Alt+Q para fechar janela"; then
    echo -e "====================================================="
    echo -e "Configurando atalho Alt+Q para fechar janela...\n"
    
    # Verificar atalho atual
    current_shortcut=$(gsettings get org.gnome.desktop.wm.keybindings close)
    echo -e "Atalho atual para fechar janela: $current_shortcut"
    
    # Definir Alt+Q como atalho para fechar janela
    gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>q']"
    
    # Verificar se foi aplicado
    new_shortcut=$(gsettings get org.gnome.desktop.wm.keybindings close)
    echo -e "Novo atalho configurado: $new_shortcut"
    
    echo -e "\nAtalho Alt+Q configurado com sucesso!"
    echo -e "Agora você pode usar Alt+Q para fechar janelas ativas"
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
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>/dev/null || true

    # Configurar o usuário para usar o Docker sem sudo
    # sudo groupadd docker
    sudo usermod -aG docker $USER
    # newgrp docker

    # Iniciar o serviço do Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    echo -e "Docker instalado com sucesso!"
    echo -e "Para usar o Docker sem sudo, reinicie o sistema ou execute: newgrp docker"

    echo -e "\n====================================================="
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

# Instalação Visual Studio Code Extensions
if ask_to_install "Visual Studio Code Extensions"; then
echo -e "====================================================="
    echo -e "Instalando Visual Studio Code Extensions...\n"

    # Lista de extensões
    extensions=(
        "bradlc.vscode-tailwindcss"
        "christian-kohler.npm-intellisense"
        "christian-kohler.path-intellisense"
        "davidanson.vscode-markdownlint"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
        "formulahendry.auto-close-tag"
        "formulahendry.code-runner"
        "github.copilot"
        "github.copilot-chat"
        "golang.go"
        "janisdd.vscode-edit-csv"
        "johnpapa.vscode-peacock"
        "mechatroner.rainbow-csv"
        "mhutchie.git-graph"
        "mikestead.dotenv"
        "ms-azuretools.vscode-containers"
        "ms-azuretools.vscode-docker"
        "ms-python.debugpy"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "pomdtr.excalidraw-editor"
        "reginaldomorais.r3-vscode-theme"
        "shd101wyy.markdown-preview-enhanced"
        "visualstudioexptteam.intellicode-api-usage-examples"
        "visualstudioexptteam.vscodeintellicode"
        "vscode-icons-team.vscode-icons"
        "yzane.markdown-pdf"
        "yzhang.markdown-all-in-one"
    )

    # Verificar se o VS Code está instalado
    if ! command -v code &> /dev/null; then
        echo "VS Code não encontrado. Instale o VS Code primeiro."
        exit 1
    fi

    # Instalar cada extensão
    for extension in "${extensions[@]}"; do
        echo -e "Instalando: $extension"
        code --install-extension "$extension" --force
    done

    echo -e "\nTodas as extensões foram instaladas no Visual Studio Code!"
fi

# Instalação Visual Studio Code Settings
if ask_to_install "Visual Studio Code Settings"; then
    echo -e "====================================================="
    echo -e "Instalando Visual Studio Code Settings...\n"
    
    if [ ! -d "~/.config/Code/User" ]; then
        echo -e "Alterando Visual Studio Code settings..."
        cat > ~/.config/Code/User/settings.json << 'EOL'
{
  "window.titleBarStyle": "custom",
  "window.dialogStyle": "custom",
  "window.newWindowDimensions": "offset",
  "window.zoomLevel": 0,

  "breadcrumbs.enabled": true,

  "explorer.sortOrder": "type",
  "explorer.confirmDragAndDrop": false,
  "explorer.confirmDelete": false,

  /* WORKBENCH */
  "workbench.startupEditor": "welcomePage",
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "R3 Theme",

  /* EDITOR */
  "editor.fontFamily": "FiraCode Nerd Font Mono",
  "editor.fontSize": 13,
  "editor.fontLigatures": true,
  "editor.rulers": [160, 180],
  "editor.tabSize": 2,
  "editor.renderWhitespace": "all",
  "editor.renderControlCharacters": true,
  "editor.glyphMargin": true,
  "editor.wordWrap": "on",
  "editor.formatOnType": true,
  "editor.tabCompletion": "on",
  "editor.trimAutoWhitespace": true,
  "editor.minimap.enabled": true,
  "editor.minimap.renderCharacters": true,
  "editor.minimap.showSlider": "always",
  "editor.dragAndDrop": true,
  "editor.mouseWheelZoom": true,
  "editor.suggestSelection": "first",
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.maxTokenizationLineLength": 2000,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "always"
  },
  "editor.inlineSuggest.enabled": true,
  "editor.unicodeHighlight.nonBasicASCII": false,

  /* BRACKET */
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",

  /* ESLINT */
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],

  /* TERMINAL */
  "terminal.integrated.fontFamily": "Firacode Nerd Font Mono",
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.lineHeight": 1.3,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.profiles.linux": { "zsh": { "path": "/bin/zsh" } },
  "terminal.integrated.profiles.osx": { "zsh": { "path": "/bin/zsh" } },
  "terminal.integrated.defaultProfile.linux": "zsh",
  "terminal.integrated.defaultProfile.osx": "zsh",

  /* FILES */
  "files.eol": "\n",
  "files.encoding": "utf8",
  "files.associations": {
    "*.jsp": "html",
    "*.gsp": "html",
    "*.js": "javascriptreact",
    "*.yml": "yaml"
  },
  "[javascript]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.insertFinalNewline": true
  },
  "[java]": {
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "files.insertFinalNewline": true
  },
  "[css]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.insertFinalNewline": true
  },
  "[html]": {
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "files.insertFinalNewline": true
  },
  "[python]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.insertFinalNewline": true,
    "editor.formatOnType": true
  },
  "[go]": {
    "editor.tabSize": 8,
    "editor.insertSpaces": false,
    "files.insertFinalNewline": true,
    "editor.defaultFormatter": "golang.go"
  },
  "[yml]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": false,
    "files.insertFinalNewline": true
  },
  "[yaml]": {
    "editor.tabSize": 2,
    "editor.insertSpaces": false,
    "files.insertFinalNewline": true
  },

  /* MARKDOWN */
  "markdown.preview.fontSize": 13,

  /* VSCODE ICONS */
  "vsicons.dontShowNewVersionMessage": true,
  "vsicons.projectDetection.autoReload": true,
  "vsicons.associations.files": [
    {
      "icon": "reactjs",
      "extensions": ["jsx"],
      "format": "svg",
      "overrides": "js"
    },
    {
      "icon": "typescript",
      "extensions": ["tsx"],
      "format": "svg",
      "overrides": "js"
    },
    {
      "icon": "js",
      "extensions": ["js"],
      "format": "svg",
      "overrides": "js"
    }
  ],

  /* PRETTIER */
  "prettier.trailingComma": "all",

  /* GIT */
  "git.autofetch": true,
  "git.confirmSync": false,

  /* PEACOCK */
  "peacock.favoriteColors": [
    {
      "name": "Angular Red",
      "value": "#b52e31"
    },
    {
      "name": "Auth0 Orange",
      "value": "#eb5424"
    },
    {
      "name": "Azure Blue",
      "value": "#007fff"
    },
    {
      "name": "C# Purple",
      "value": "#68217A"
    },
    {
      "name": "Gatsby Purple",
      "value": "#639"
    },
    {
      "name": "Go Cyan",
      "value": "#5dc9e2"
    },
    {
      "name": "Java Blue-Gray",
      "value": "#557c9b"
    },
    {
      "name": "JavaScript Yellow",
      "value": "#f9e64f"
    },
    {
      "name": "Mandalorian Blue",
      "value": "#1857a4"
    },
    {
      "name": "Node Green",
      "value": "#215732"
    },
    {
      "name": "React Blue",
      "value": "#00b3e6"
    },
    {
      "name": "Something Different",
      "value": "#832561"
    },
    {
      "name": "Something Different",
      "value": "#42b883"
    }
  ],

  /* JAVASCRIPT */
  "javascript.updateImportsOnFileMove.enabled": "always",

  /* TYPESCRIPT */
  "typescript.updateImportsOnFileMove.enabled": "always",

  /* GO */
  "go.useLanguageServer": true,
  "go.toolsManagement.autoUpdate": true,
  "files.exclude": {
    "**/.classpath": true,
    "**/.project": true,
    "**/.settings": true,
    "**/.factorypath": true
  },

  /* HINT JS */
  "javascript.inlayHints.parameterNames.enabled": "none",
  "javascript.inlayHints.enumMemberValues.enabled": true,
  "javascript.inlayHints.functionLikeReturnTypes.enabled": true,
  "javascript.inlayHints.parameterTypes.enabled": true,
  "javascript.inlayHints.propertyDeclarationTypes.enabled": true,
  "javascript.inlayHints.variableTypes.enabled": true,

  /* HINT TS */
  "typescript.inlayHints.parameterNames.enabled": "none",
  "typescript.inlayHints.parameterTypes.enabled": true,
  "typescript.inlayHints.enumMemberValues.enabled": true,
  "typescript.inlayHints.functionLikeReturnTypes.enabled": true,
  "typescript.inlayHints.propertyDeclarationTypes.enabled": true,
  "typescript.inlayHints.variableTypes.enabled": true,

  "security.workspace.trust.untrustedFiles": "open",

  /* Copilot */
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "plaintext": true,
    "markdown": true
  }
}
EOL
        echo -e "Visual Studio Code settings alterado!"
    else
        echo -e "Visual Studio Code Settings não encontrado!"
    fi
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
    wget https://downloads.slack-edge.com/desktop-releases/linux/x64/4.43.51/slack-desktop-4.43.51-amd64.deb
    sudo dpkg -i slack-desktop-4.43.51-amd64.deb
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
    sdk install java 21.0.7-zulu

    # Instala Java mais recente
    sdk install gradle

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
    GOLANG_VERSION="1.24.4"  # Ajuste para a versão mais recente se necessário
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
    source ~/.bashrc
    source ~/.zshrc
    
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

# Instalação do .commands-extension.sh
if ask_to_install ".commands-extension.sh"; then
    echo -e "====================================================="
    echo -e "Criando .commands-extension.sh...\n"

    cat >> ~/.commands-extension.sh << 'EOL'
##############################################################################
#  FUNCTIONS                                                                 #
##############################################################################

function echoGitAliases() {
  echo "
:: GIT ALIASES ::

| Alias      | Command                                                         | Description                   |
| ---------- | --------------------------------------------------------------- | ----------------------------- |
| i          | init                                                            | Git Init                      |
| cl         | clone                                                           | Clone repository              |
| me         | config user.name                                                | Config user                   |
| em         | config user.email                                               | Config email                  |
| a          | add                                                             | Add file to stage             |
| all        | add .                                                           | Add all file to stage         |
| psu        | push origin main -u                                             | Push to main                  |
| por        | push origin master -u                                           | Push to master                |
| ps         | push origin                                                     | Push to origin                |
| pl         | pull origin                                                     | Push to origin                |
| fe         | fetch                                                           | Fetch                         |
| ci         | '!f() { git commit -m \'\$\*\'; }; f'                           | Commit with message           |
| co         | checkout                                                        | Checkout to some branch       |
| cn         | checkout main                                                   | Checkout to main              |
| cr         | checkout master                                                 | Checkout to master            |
| cd         | checkout develop                                                | Checkout to develop           |
| cb         | checkout -b                                                     | Checkout to new branch        |
| rt         | remote                                                          | Remote                        |
| s          | status                                                          | Status                        |
| st         | status -sb                                                      | Less verbose status           |
| sf         | show --name-only                                                | Show last commit name         |
| lgo        | log --graph --oneline                                           | Pretty log                    |
| lg         | log --pretty=format:'%Cred%h%Creset %C(bold)%cr%Creset ...      | Pretty log                    |
| incoming   | !(git fetch --quiet && git log --pretty=format:... ...@{u})     | Remote commits ahead of mine  |
| outgoing   | !(git fetch --quiet && git log --pretty=format:... ...@{u}..)   | Remote commits ahead of local |
| unstage    | reset HEAD --                                                   | The missing command <3        |
| undo       | checkout --                                                     | Undo modifications to a file  |
| rollback   | reset --soft HEAD~1                                             | Soft reset                    |
| standup    | !(git log --color --graph --pretty=format:'%Cred%h%Creset...    | Last 24 hours commits         |
| ready      | rebase -i @{u}                                                  | Review commits before pushing |
| hier       | log --all --graph --decorate --oneline --simplify-by-decoration | Branchs hier                  |
| committers | !(git log \| grep Author \| sort \| uniq -c \| sort -n -r)      | List committers               |
"
}

function echoMyAliases() {
  echo "
:: MY ALIASES ::

| Alias   | Command                        | Description                                               |
| ------- | ------------------------------ | --------------------------------------------------------- |
| aptu    | sudo apt update && apt upgrade | Configure python 3.11 version.                            |
| zreload | omz reload                     | Reload oh-my-zsh.                                         |
| d       | docker                         | Execute Docker cli commands.                              |
| kl      | kubectl                        | Execute Kubectl cli commands.                             |
| kd      | Kind                           | Execute Kind cli commands.                                |
| g       | git                            | Execute Git cli commands.                                 |
| ga      | git                            | Git aliases.                                              |
| gitslow | gitslow                        | Configure git ssh slow pull and push.                     |
| vs      | code                           | Vs code open folder.                                      |
| cl      | clear                          | Clean terminal.                                           |
| ncu     | ncu                            | Show dependencies available updates on package.json.      |
| npmkill | npmkill                        | Delete all node_modules folders.                          |
| py9     | python3 -m venv .venv          | Configure python 3.9 version.                             |
| py11    | python3 -m venv .venv          | Configure python 3.11 version.                            |
| astc    | conviso ast run                | Execute Conviso AST.                                      |
| camv    | gp-cam                         | Execute Webcam checker.                                   |
"
}

function runNpmKill() {
  npx npkill
}

function runNcu() {
  npx npm-check-updates
}

function runGitslow() {
  touch ~/.ssh/config
  echo "AddressFamily inet" > ~/.ssh/config
}

function runPy9() {
  pyenv local 3.9 
  python3 -m venv .venv
  source .venv/bin/activate 
  pip install --upgrade pip 
  pip install -r requirements.txt
}

function runPy11() {
  pyenv local 3.11 
  python3 -m venv .venv
  source .venv/bin/activate 
  pip install --upgrade pip 
  pip install -r requirements.txt
}

function runAPTUpdate() {
  echo "APT update"
  sudo apt update
  echo "APT update -y"
  sudo apt update -y
}

function runOhMyZshReload() {
  omz reload
}

function runCamChecker() {
  /home/reginaldomorais/Workspaces/my/go-cam/go-cam
}

function runConvisoAST() {
  if ! command -v conviso &> /dev/null; then
    echo "ERRO: conviso-cli não está instalado. Por favor, instale com 'pip install conviso-cli' antes de continuar."
  else
    export CONVISO_API_KEY="TYWX0-5iphb3hWEX_fx8QGrgHrE6h2N9qEi2m4lVx4Q" && export CONVISO_COMPANY_ID="905" && conviso ast run --vulnerability-auto-close && rm -Rf conviso-* && docker rm $(docker ps -a --filter "name=conviso-cli-*" -q)
  fi
}

alias als=echoMyAliases
alias kind=$HOME/Applications/kind
alias d=docker
alias kl=kubectl
alias kd=kind
alias g=git
alias gals=echoGitAliases
alias vs=code
alias cl=clear
alias npmkill=runNpmKill
alias ncu=runNcu
alias gitslow=runGitslow
alias py9=runPy9
alias py11=runPy11
alias aptu=runAPTUpdate
alias zreload=runOhMyZshReload
alias astc=runConvisoAST
alias camv=runCamChecker


##############################################################################
#  PATH EXPORTS                                                              #
##############################################################################

# NVM - Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SDKMAN - Java Version Manager
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# pyenv - Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOL

cat >> ~/.bashrc << 'EOL'
if [ -f ~/.commands-extension.sh ]; then
    echo "Loading ~/.commands-extension.sh"
    source ~/.commands-extension.sh
fi
EOL

    if [ -f ~/.zshrc ]; then
            cat >> ~/.zshrc << 'EOL'

if [ -f ~/.commands-extension.sh ]; then
    echo "Loading ~/.commands-extension.sh"
    source ~/.commands-extension.sh
fi

EOL
    fi

    echo -e "\nArquivo .commands-extension.sh criado com sucesso!"
fi

echo -e "\n\n====================================================="
echo -e "Instalação finalizada!"
echo -e "\nPara que todas as ferramentas funcionem corretamente, execute:"
echo -e "source ~/.bashrc"
if [ -f ~/.zshrc ]; then
    echo -e "Para ativar o Oh My Zsh, execute: zsh"
    echo -e "Para tornar o zsh seu shell padrão, execute: chsh -s $(which zsh)"
    echo -e "Para configurar o tema Powerlevel10k, execute: p10k configure"
fi
echo -e "Para iniciar o Guake Terminal, execute: guake"
echo -e "====================================================="
