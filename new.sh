#!/bin/bash

# Function to append to .bashrc if the line doesn't already exist
append_to_bashrc() {
  local line="$1"
  grep -qxF "$line" ~/.bashrc || echo "$line" >> ~/.bashrc
}

# Update package lists
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    zlib1g-dev \
    ca-certificates \
    lsb-release \
    apt-transport-https \
    software-properties-common

# Install Docker
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt-get update

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start Docker and enable it to run at startup
sudo systemctl start docker
sudo systemctl enable docker

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Load nvm and append to .bashrc
append_to_bashrc 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"'
append_to_bashrc '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm'
append_to_bashrc '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion'

# Source .bashrc to load nvm
source ~/.bashrc

# Install PyENV
curl https://pyenv.run | bash

# Load pyenv and append to .bashrc
append_to_bashrc 'export PATH="$HOME/.pyenv/bin:$PATH"'
append_to_bashrc 'eval "$(pyenv init --path)"'
append_to_bashrc 'eval "$(pyenv init -)"'
append_to_bashrc 'eval "$(pyenv virtualenv-init -)"'

# Source .bashrc to load pyenv
source ~/.bashrc

# Create new user 'pacyheb'
sudo adduser --disabled-password --gecos "" pacyheb

# Copy SSH key from root to pacyheb
sudo mkdir -p /home/pacyheb/.ssh
sudo cp /root/.ssh/authorized_keys /home/pacyheb/.ssh/
sudo chown -R pacyheb:pacyheb /home/pacyheb/.ssh
sudo chmod 700 /home/pacyheb/.ssh
sudo chmod 600 /home/pacyheb/.ssh/authorized_keys

# Create /projects directory and set pacyheb as the owner
sudo mkdir -p /projects
sudo chown -R pacyheb:pacyheb /projects

# Modify sudoers file to allow pacyheb to execute commands without a password
echo 'pacyheb ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/pacyheb

# Print completion message
echo "Installation and setup of Docker, NVM, PyENV, and user 'pacyheb' with passwordless sudo completed successfully."

# Optionally, you can add more logic to install specific versions of Node.js and Python using nvm and pyenv.