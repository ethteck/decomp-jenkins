#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Not enough arguments."
    echo "Usage: uninstall.sh <agent_name> <purge_flag>"
    echo "If purge flag is set to true, then the decomp agent user and files will be purged from the system. NOTE that docker will not be uninstalled."
    exit
fi

agentName=$1
purge=0
errors=0

if [[ $# -gt 1 ]]; then
    echo "'$agentName' user will also purged from your system!"
    read -n 1 -s -r -p "Press any key to continue"
    purge=$2
fi

if [[ -f /etc/systemd/system/decomp-jenkins.service ]]; then
    sudo systemctl stop decomp-jenkins
    if [[ $? -ne 0 ]]; then
        if [[ $? -ne 3 ]]; then
            if [[ $? -ne 4 ]]; then
                echo "There was a problem stopping the decomp-jenkins service. Continuing..."
                errors=1
            fi
        fi
    fi

    sudo systemctl disable decomp-jenkins
    if [[ $? -ne 0 ]]; then
        if [[ $? -ne 3 ]]; then
            if [[ $? -ne 4 ]]; then
                echo "There was a problem disabling the decomp-jenkins service. Continuing..."
                errors=1
            fi
        fi
    fi

    sudo rm -rf /etc/systemd/system/decomp-jenkins.service
    if [[ $? -ne 0 ]]; then
        echo "There was a problem removing the decomp-jenkins service. Continuing..."
        errors=1
    fi
fi

if [[ $purge -ne 0 ]]; then
    sudo userdel $agentName
    if [[ $? -ne 0 ]]; then
        if [[ $? -ne 6 ]]; then
            echo "There was a problem removing the '$agentName' user. Continuing..."
            errors=1
        fi
    fi

    sudo rm -rf /home/$agentName/
    if [[ $? -ne 0 ]]; then
        echo "There was a problem removing the '$agentName' home directory. Continuing..."
        errors=1
    fi
fi

echo "Uninstallation complete."
if [[ $errors -ne 0 ]]; then
    echo "It appears there were errors in the uninstallation process. Please check the output and resolve any issues, then try running this script again. If errors persist, you may need to perform manual cleanup."
fi

