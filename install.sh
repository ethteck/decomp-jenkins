#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Not enough arguments."
    echo "Usage: install.sh <agent_name> <rom_directory> <agent_secret>"
    exit
fi

agentName=$1
romPath=$2
agentSecret=$3

sudo apt-get install docker.io
if [[ $? -ne 0 ]]; then
    echo "Failed to install docker."
    exit
fi

sudo useradd $agentName -g docker -m -s /bin/bash
if [[ $? -ne 0 ]]; then
    if [[ $? -eq 9 ]]; then
        echo "User already exists, continuing..."
    else
        echo "Failed to add user for docker agent"
    fi
fi

if [[ ! -d /home/$agentName/decomp-jenkins ]]; then
    sudo git clone https://github.com/ethteck/decomp-jenkins /home/$agentName/decomp-jenkins
    if [[ $? -ne 0 ]]; then
        echo "Failed to clone decomp-jenkins repository"
        exit
    fi
else
    echo "decomp-jenkins repository is already cloned. Updating repository..."
    sudo git -C /home/$agentName/decomp-jenkins/ pull
    if [[ $? -ne 0 ]]; then
        echo "Failed to pull decomp-jenkins repository"
        exit
    fi
fi

sudo mkdir -p /home/$agentName/decomp-jenkins/roms
if [[ $? -ne 0 ]]; then
    echo "Failed to create installation directory."
    exit
fi

echo "$agentSecret" | sudo tee /home/$agentName/decomp-jenkins/jenkins-secret
if [[ $? -ne 0 ]]; then
    echo "Failed to create jenkins secret file."
    exit
fi

sudo chown -R $agentName /home/$agentName/decomp-jenkins/
if [[ $? -ne 0 ]]; then
    echo "Failed to set owner of decomp-jenkins directory."
    exit
fi

sudo su - $agentName -c 'docker build $HOME/decomp-jenkins -t decomp'
if [[ $? -ne 0 ]]; then
    echo "Failed to build docker image"
    exit
fi

sudo cp $2/* /home/$agentName/decomp-jenkins/roms
if [[ $? -ne 0 ]]; then
    echo "Failed to copy roms from $2"
    exit
fi

if [[ -f /etc/systemd/system/decomp-jenkins.service ]]; then
    echo "Service is already installed. Uninstalling to provision the newest version."
    sudo systemctl stop decomp-jenkins >> /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed to stop decomp-jenkins service."
        exit
    fi

    sudo systemctl disable decomp-jenkins >> /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed to disable decomp-jenkins service."
        exit
    fi
fi

sudo install -o root -g root -m 644 /home/caine/decomp-jenkins/decomp-jenkins.service /etc/systemd/system/decomp-jenkins.service
if [[ $? -ne 0 ]]; then
    echo "Failed to install service file"
    exit
fi

sudo sed -i "s/<AGENT_NAME>/$agentName/g" /etc/systemd/system/decomp-jenkins.service
if [[ $? -ne 0 ]]; then
    echo "Failed to update <AGENT_NAME> in the service file"
    exit
fi

sudo systemctl enable decomp-jenkins
if [[ $? -ne 0 ]]; then
    echo "Failed to enable decomp-jenkins service"
    exit
fi

sudo systemctl start decomp-jenkins
if [[ $? -ne 0 ]]; then
    echo "Failed to start decomp-jenkins service"
    exit
fi

echo "Decomp agent successfully installed under user $agentName"
echo "To check the status of the service, you can run 'sudo systemctl status decomp-jenkins.service'"
echo "To uninstall the decomp agent, you can run 'uininstall.sh <agent_name>'. If you would like to purge the user that is installed with this package, run 'uninstall.sh <agent_name> 1'"

