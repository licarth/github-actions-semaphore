#!/bin/bash
set +x;
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    Mac*)       machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [[ "$machine" == "Linux"* ]]; then
    echo "Installing myke for Linux..."
    sudo wget -qO /usr/local/bin/myke https://github.com/omio-labs/myke/releases/download/v1.0.2/myke_linux_amd64
    sudo chmod +x /usr/local/bin/myke
elif [[ "$machine" == "Mac"* ]]; then
    echo "Installing myke for MacOs..."
    wget -qO /usr/local/bin/myke https://github.com/omio-labs/myke/releases/download/v1.0.2/myke_darwin_amd64
    chmod +x /usr/local/bin/myke
else
    echo "Unsupported OS."
    exit 1
fi
myke --version
echo "myke successfully installed."
