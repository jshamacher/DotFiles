#!/bin/sh

# Undo directory.
mkdir -p ~/.vim/undodir

# Plugins.
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle

# Pathogen makes everything else work.
if [ ! -d pathogen ]; then
    git clone https://github.com/tpope/vim-pathogen.git pathogen
else
    cd pathogen
    git pull --rebase
    cd ..
fi

# Various tools.
if [ ! -d fugitive ]; then
    git clone https://github.com/tpope/vim-fugitive.git   fugitive
else
    cd fugitive
    git pull --rebase
    cd ..
fi
if [ ! -d rails ]; then
    git clone https://github.com/tpope/vim-rails.git      rails
else
    cd rails
    git pull --rebase
    cd ..
fi
if [ ! -d slime ]; then
    git clone https://github.com/jpalardy/vim-slime.git   slime
else
    cd slime
    git pull --rebase
    cd ..
fi
if [ ! -d syntastic ]; then
    git clone https://github.com/scrooloose/syntastic.git syntastic
else
    cd syntastic
    git pull --rebase
    cd ..
fi
if [ ! -d aftercolors ]; then
    git clone https://github.com/vim-scripts/AfterColors.vim.git aftercolors
else
    cd aftercolors
    git pull --rebase
    cd ..
fi
if [ ! -d vim-airline ]; then
    git clone https://github.com/bling/vim-airline.git vim-airline
else
    cd vim-airline
    git pull --rebase
    cd ..
fi
if [ ! -d vim-terraform ]; then
    git clone https://github.com/hashivim/vim-terraform.git vim-terraform
else
    cd vim-terraform
    git pull --rebase
    cd ..
fi
if [ ! -d vim-obsession ]; then
    git clone https://github.com/tpope/vim-obsession.git vim-obsession
else
    cd vim-obsession
    git pull --rebase
    cd ..
fi

# Color schemes.
if [ ! -d solarized ]; then
    git clone https://github.com/altercation/vim-colors-solarized.git solarized
else
    cd solarized
    git pull --rebase
    cd ..
fi
if [ ! -d railscasts ]; then
    git clone https://github.com/jgdavey/vim-railscasts.git railscasts
else
    cd railscasts
    git pull --rebase
    cd ..
fi
if [ ! -d molokai ]; then
    git clone https://github.com/tomasr/molokai.git molokai
else
    cd molokai
    git pull --rebase
    cd ..
fi

if [ ! -d zenburn ]; then
    git clone https://github.com/vim-scripts/Zenburn.git zenburn
else
    cd zenburn
    git pull --rebase
    cd ..
fi

if [ ! -d jellybeans ]; then
    git clone https://github.com/nanotech/jellybeans.vim.git jellybeans
else
    cd jellybeans
    git pull --rebase
    cd ..
fi

if [ ! -d seoul256 ]; then
    git clone https://github.com/junegunn/seoul256.vim.git seoul256
else
    cd seoul256
    git pull --rebase
    cd ..
fi

if [ ! -d gruvbox ]; then
    git clone https://github.com/morhetz/gruvbox.git gruvbox
else
    cd gruvbox
    git pull --rebase
    cd ..
fi
