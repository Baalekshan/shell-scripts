#!/bin/bash
echo "Installation of Git started"
if ["$(uname)" == "Linux"];
then 
        echo "Installing Git in Linux"
        apt install git -y
elif ["$(uname)" == "Darwin"];
then
    echo "Installing Git in MacOS"
    brew install git
else
    echo "Error: cant install git"
fi