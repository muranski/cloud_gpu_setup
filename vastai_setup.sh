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

# Resolve the directory of the script
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set up time zone to UTC
timezone='Etc/UTC'
ln -snf "/usr/share/zoneinfo/${timezone}" /etc/localtime
echo "${timezone}" > /etc/timezone

# # Restore minimized packages to make this system more suitable for interactive use.
# yes | unminimize

# Update and upgrade package list, and install specified packages
apt-get update
apt-get -y upgrade
# apt-get -y install emacs htop man pass pipx python3 transmission-cli xclip || {
#     echo 'Package installation failed'
#     exit 1
# }
apt-get -y install emacs htop pipx python3 transmission-cli xclip || {
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

# Define custom commands
echo "
# Custom commands.
cdp() {
    cd /workspace/p/\"\$1\"
}
_cdp() {
    local cur=\${COMP_WORDS[COMP_CWORD]}
    local IFS=\$'\n'
    local base_path=/workspace/p/
    local options=($(compgen -d \"\${base_path}\${cur}\" | sed \"s|\${base_path}||\"))
    COMPREPLY=(\"\${options[@]}\")
}
complete -F _cdp cdp
" >> ~/.bashrc

# Set up emacs as the default editor
cp -R "${dir}/.emacs.d" ~
{
    echo
    echo "export EDITOR='emacs -nw'"
    echo 'alias e="${EDITOR}"'
} >> ~/.bashrc

# Set up git
cp "${dir}/.gitconfig" ~
cp "${dir}/.gitignore_global" ~

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
