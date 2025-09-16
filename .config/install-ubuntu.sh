#!/bin/bash
# Script to add multiple APT repositories for Ubuntu Noble, only if not already present (with GPG key checks)
DIST=$(lsb_release -c -s 2>/dev/null || . /etc/os-release && echo "$VERSION_CODENAME")
VERSION=$(lsb_release -r -s 2>/dev/null || . /etc/os-release && echo "$VERSION_ID")

# Apptainer
if [ ! -f /etc/apt/sources.list.d/apptainer-ubuntu-ppa-${DIST}.sources ]; then
  sudo add-apt-repository -y ppa:apptainer/ppa
fi

# Docker
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.gpg >/dev/null
  fi
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${DIST} stable" | sudo tee /etc/apt/sources.list.d/docker.list
fi

# GitHub CLI
if [ ! -f /etc/apt/sources.list.d/github-cli.list ]; then
  if [ ! -f /usr/share/keyrings/githubcli-archive-keyring.gpg ]; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null
  fi
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
fi

# HashiCorp
if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
  if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
  fi
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${DIST} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
fi

# Nextcloud client
if [ ! -f /etc/apt/sources.list.d/nextcloud-devs-ubuntu-client-${DIST}.sources ]; then
  sudo add-apt-repository -y ppa:nextcloud-devs/client
fi

# Signal
if [ ! -f /etc/apt/sources.list.d/signal-xenial.list ]; then
  # apt-key is deprecated, but Signal still uses it
  wget -O- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
  echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list
fi

# Uberzug++ (openSUSE Build Service)
if [ ! -f /etc/apt/sources.list.d/home:justkidding.list ]; then
  echo "deb http://download.opensuse.org/repositories/home:/justkidding/xUbuntu_${VERSION}/ /" | sudo tee /etc/apt/sources.list.d/home:justkidding.list
  if [ ! -f /etc/apt/trusted.gpg.d/home_justkidding.gpg ]; then
    curl -fsSL https://download.opensuse.org/repositories/home:justkidding/xUbuntu_${VERSION}/Release.key | sudo tee /etc/apt/trusted.gpg.d/home_justkidding.gpg >/dev/null
  fi
fi

# WezTerm
if [ ! -f /etc/apt/sources.list.d/wezterm.list ]; then
  if [ ! -f /usr/share/keyrings/wezterm-fury.gpg ]; then
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
  fi
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
fi

# Update package lists
sudo apt update
