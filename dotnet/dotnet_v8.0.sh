#!/bin/bash
mkdir /home/maropakis.a/dotnet8
cd /home/maropakis.a/dotnet8
wget https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.421/dotnet-sdk-8.0.421-linux-x64.tar.gz
tar -xzf dotnet-sdk-8.0.421-linux-x64.tar.gz
rm dotnet-sdk-8.0.421-linux-x64.tar.gz

export DOTNET_ROOT=$HOME/dotnet8
export PATH=$DOTNET_ROOT:$PATH
echo dotnet --version
