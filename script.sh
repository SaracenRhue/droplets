#!/bin/bash

# Ensure the script is run as root, otherwise restart it with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script needs to be run as root. Trying to restart with sudo..."
    exec sudo bash "$0" "$@"
    exit $?
fi

# Install dialog if it's not already installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog not found. Installing dialog..."
    apt-get update && apt-get install -y dialog
fi

# Define functions for each task
update_system() {
    echo "Updating system..."
    apt-get update && apt-get upgrade -y
    echo "System updated."
}

install_tailscale() {
    echo "Installing Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
    echo "Tailscale installed."
}

setup_docker() {
    echo "Setting up Docker..."
    curl -fsSL https://get.docker.com | sh
    apt-get install -y docker-compose
    systemctl enable docker
    systemctl start docker
    echo "Docker setup completed."
}

setup_python() {
    echo "Setting up Python..."
    apt-get install -y python3 python3-pip
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1
    echo "Python setup completed."
}

# Show dialog checklist and capture selections
exec 3>&1
selections=$(dialog \
    --backtitle "Setup Menu" \
    --title "Select options" \
    --clear \
    --cancel-label "Exit" \
    --checklist "Please select:" 15 50 4 \
    1 "Update system" off \
    2 "Install Tailscale" off \
    3 "Setup Docker" off \
    4 "Setup Python" off \
    2>&1 1>&3)
exit_status=$?
exec 3>&-

# Check if the user canceled or closed the dialog
if [ $exit_status -ne 0 ]; then
    echo "No selection made or dialog was cancelled."
    exit 1
fi

# Process selections
if [[ $selections =~ "1" ]]; then update_system; fi
if [[ $selections =~ "2" ]]; then install_tailscale; fi
if [[ $selections =~ "3" ]]; then setup_docker; fi
if [[ $selections =~ "4" ]]; then setup_python; fi

echo "All selected tasks have been completed."
