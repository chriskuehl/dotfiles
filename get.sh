#!/bin/bash -eux
git clone https://github.com/chriskuehl/dotfiles ~/.dotfiles
cd ~/.dotfiles
./update.py
