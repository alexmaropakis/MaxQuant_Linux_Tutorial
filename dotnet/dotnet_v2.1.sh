#!/bin/bash 

mkdir /home/maropakis.a/dotnet
cd /home/maropakis.a/dotnet
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/2.1.818/dotnet-sdk-2.1.818-linux-x64.tar.gz
tar -xzf dotnet-sdk-2.1.818-linux-x64.tar.gz
rm dotnet-sdk-2.1.818-linux-x64.tar.gz

export DOTNET_ROOT=$HOME/dotnet
export PATH=$DOTNET_ROOT:$PATH
source ~/.bashrc

echo dotnet --version
