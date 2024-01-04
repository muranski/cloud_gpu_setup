#!/usr/bin/env bash

# Enable verbose and strict error handling mode
set -xEeu
trap 'echo "Error in command: $BASH_COMMAND. Exiting..."' ERR

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Set the internal field separator
IFS=$'\n\t'

# Check if GIT_USER_NAME and GIT_USER_EMAIL are set
if [[ ! -v GIT_USER_NAME ]] || [[ ! -v GIT_USER_EMAIL ]]; then
    echo "GIT_USER_NAME and GIT_USER_EMAIL must be set"
    exit 1
fi

# Resolve the directory of the script
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set up time zone to UTC
timezone='Etc/UTC'
ln -snf "/usr/share/zoneinfo/${timezone}" /etc/localtime
echo "${timezone}" > /etc/timezone

# Restore minimized packages to make this system more suitable for interactive use.
yes | unminimize

# Update and upgrade package list, and install specified packages
apt-get update
apt-get -y upgrade
apt-get -y install emacs man pass pipx transmission-cli xclip || {
    echo 'Package installation failed'
    exit 1
}

# Ensure ~/.bashrc exists and is writable
touch ~/.bashrc

# Backup existing .bashrc
bashrc_backup=~/.bashrc.$(date +%Y%m%dT%H%M%S)
cp ~/.bashrc $bashrc_backup

# Configure bash history
{
    echo
    echo 'export HISTSIZE=100000'
    echo 'export HISTFILESIZE=$HISTSIZE'
    echo "export HISTIGNORE='pwd:history'"
} >> ~/.bashrc

# Set up emacs as the default editor
cp -R "${dir}/.emacs.d" ~
{
    echo
    echo "export EDITOR='emacs -nw'"
    echo 'alias e="${EDITOR}"'
} >> ~/.bashrc

# Configure Git
cp "${dir}/.gitconfig" ~
cp "${dir}/.gitignore_global" ~
git config --global user.name "${GIT_USER_NAME}"
git config --global user.email "${GIT_USER_EMAIL}"

# Install and configure git-credential-manager
wget "https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.4.1/gcm-linux_amd64.2.4.1.deb" -O /tmp/gcmcore.deb
dpkg -i /tmp/gcmcore.deb
export GCM_CREDENTIAL_STORE=cache
git-credential-manager configure

# Configure pipx
pipx ensurepath
pipx install argcomplete
echo 'eval "$(register-python-argcomplete pipx)"' >> ~/.bashrc

# Configure Pipenv
pipx install pipenv
{
    echo
    echo 'export PIPENV_VENV_IN_PROJECT=1'
} >> ~/.bashrc

# Create working directories for datasets and projects
mkdir -p /workspace/d /workspace/p

echo 'Vast.ai workstation setup completed successfully. The system is ready for use!'
