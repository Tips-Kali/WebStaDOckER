#!/bin/sh

environment=$1;

# Installation de Glance
if [ ${environment} != "development" ]; then
    echo "Installer Glances ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        show "MISE EN PLACE DE 'GLANCES'";
        installedGlance="oui";
        apt-get -y install curl;
        curl -L http://bit.ly/glances | /bin/bash;
    fi
fi

# Outils de travail
if [ ${environment} == "development" ]; then
    echo "Installer Java, phpStorm, SmartGit... ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        # Java
        echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list;
        echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list;
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886;
        apt-get update -y;
        apt-get -y install oracle-java8-installer;

        # PhpStorm
        wget http://download-cf.jetbrains.com/webide/PhpStorm-8.0.1.tar.gz;
        tar -xzvf PhpStorm-8.0.1.tar.gz;
        rm -f PhpStorm-8.0.1.tar.gz;
        /bin/sh PhpStorm-138.2001.2328/bin/phpstorm.sh;

        # SmartGit
        wget http://www.syntevo.com/smartgit/download?file=smartgit/smartgit-6_5_0.deb;
        dpkg -i smartgit-6_5_0.deb;
        rm -f smartgit-6_5_0.deb;
    fi

    echo "Installer PgAdmin 3 ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        apt-get install -y pgadmin3;
    fi
fi

# Installation de NeoVIM
if [ ${environment} != "development" ]; then
    echo "Installer NeoVIM ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        cd ~;
        apt-get install libtool autoconf automake cmake libncurses5-dev g++ pkg-config;
        wget https://github.com/neovim/neovim/archive/master.zip;
        unzip master.zip;
        cd neovim-master;
        make;
        cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/;
        make install;
        cd ~;
        rm -rf neovim-master;
        rm -f master.zip;
        mkdir -p ~/.nvim/bundle ~/.nvim/autoload;
        touch ~/.nvimrc;

        # Plugin Pathogen
        curl -LSso ~/.nvim/autoload/pathogen.vim https://tpo.pe/pathogen.vim;
        echo 'execute pathogen#infect()' >> ~/.nvimrc;
        echo 'syntax on' >> ~/.nvimrc;
        echo 'filetype plugin indent on' >> ~/.nvimrc;

        # Plugin NERD Tree
        cd ~/.nvim/bundle && git clone https://github.com/scrooloose/nerdtree.git;
        echo 'autocmd VimEnter * NERDTree' >> ~/.nvimrc;

        # Plugin VIM Markdown
        cd ~/.nvim/bundle && git clone https://github.com/plasticboy/vim-markdown.git;

        # ColorScheme
        cd ~/.nvim/bundle && git clone https://github.com/morhetz/gruvbox.git;
        echo 'colorscheme gruvbox' >> ~/.nvimrc;

        # Désinstallation de nano
        apt-get -y remove nano vim;
    fi
fi