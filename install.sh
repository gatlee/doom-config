#!/usr/bin/env bash
[ -d "$HOME/.doom.d" ] && echo "Directory ~/doom.d exists" && exit 0;
ln -s $(pwd) $HOME/.doom.d
