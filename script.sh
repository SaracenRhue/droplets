#!/bin/bash

# Check if the script is run as root, if not, try to restart it with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "Attempting to restart the script with root privileges..."
    exec sudo bash "$0" "$@"
    exit $?
fi

# Install dialog if not already installed
if ! command -v dialog &> /dev/null; then
    echo "Dialog not found. Installing dialog..."
    apt update && apt install -y dialog
fi

# Define the dialog exit status codes
: "${DIALOG_OK=0}"
: "${DIALOG_CANCEL=1}"
: "${DIALOG_ESC=255}"

# Function to update system
update_system() {
    echo "Updating system..."
    apt update && apt upgrade -y
}

# Function to install Tailscale
install_tailscale() {
    echo "Installing Tailscale..."
    curl -fsSL https://tailscale.com/install.sh | sh
}

# Function to setup Docker
setup_docker() {
    echo "Setting up Docker..."
    curl -fsSL https://get.docker.com | sh && apt install docker-compose -y && systemctl enable docker && systemctl start docker
}

# Function to setup Python
setup_python() {
    echo "Setting up Python..."
    apt install -y python3 python3-pip python-is-python3
}

# Show dialog checklist
exec 3>&1
selection=$(dialog \
    --backtitle "Setup Menu" \
    --title "Select options" \
    --clear \
    --cancel-label "Exit" \
    --checklist "Please select:" 0 0 4 \
    "1" "Update system" off \
    "2" "Install Tailscale" off \
    "3" "Setup Docker" off \
    "4" "Setup Python" off \
    2>&1 1>&3)
exit_status=$?
exec 3>&-

# Exit if user cancels or escapes the dialog
[[ $exit_status -eq $DIALOG_CANCEL ]] || [[ $exit_status -eq $DIALOG_ESC ]] && clear && exit

# Parse selections and call functions accordingly
for choice in $selection; do
    case $choice in
        '"1"')
            update_system
            ;;
        '"2"')
            install_tailscale
            ;;
        '"3"')
            setup_docker
            ;;
        '"4"')
            setup_python
            ;;
    esac
done
