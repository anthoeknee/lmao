#!/bin/bash

# Update and upgrade packages
sudo apt-get update && sudo apt-get upgrade -y

# Create a new user pacyheb and add SSH key
sudo adduser --disabled-password --gecos "" pacyheb
sudo mkdir -p /home/pacyheb/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgPu8e2WvqIctYKkwttKXGfU4GIuNhaPb3u7fUlG1zz" | sudo tee /home/pacyheb/.ssh/authorized_keys
sudo chown -R pacyheb:pacyheb /home/pacyheb/.ssh
sudo chmod 600 /home/pacyheb/.ssh/authorized_keys

# Grant sudo privileges without a password
echo 'pacyheb ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/90-cloud-init-users

# Create /projects directory and set ownership
sudo mkdir -p /projects
sudo chown pacyheb:pacyheb /projects

# Install Docker
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker pacyheb

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install doctl (DigitalOcean CLI)
sudo snap install doctl

# Install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Install NVM (Node Version Manager)
su - pacyheb -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash"
su - pacyheb -c "echo 'export NVM_DIR=\"$HOME/.nvm\"' >> ~/.bashrc"
su - pacyheb -c "echo '[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"' >> ~/.bashrc"

# Install Pyenv
su - pacyheb -c "curl https://pyenv.run | bash"
su - pacyheb -c "echo 'export PATH=\"$HOME/.pyenv/bin:$PATH\"' >> ~/.bashrc"
su - pacyheb -c "echo 'eval \"$(pyenv init --path)\"' >> ~/.bashrc"
su - pacyheb -c "echo 'eval \"$(pyenv virtualenv-init -)\"' >> ~/.bashrc"

# Optional security enhancements

# Install and configure Fail2Ban
sudo apt-get install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Install and configure UFW
sudo apt-get install -y ufw
sudo ufw allow OpenSSH
sudo ufw --force enable