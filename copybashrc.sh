#!/bin/bash

# Function to append to .bashrc if the line doesn't already exist
append_to_bashrc() {
  local line="$1"
  local bashrc="$2"
  grep -qxF "$line" "$bashrc" || echo "$line" >> "$bashrc"
}

# Paths to the user's and pacyheb's .bashrc
ROOT_BASHRC="/root/.bashrc"
PACYHEB_BASHRC="/home/pacyheb/.bashrc"

# Append NVM activation commands to pacyheb's .bashrc
append_to_bashrc 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"' "$PACYHEB_BASHRC"
append_to_bashrc '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' "$PACYHEB_BASHRC"
append_to_bashrc '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion' "$PACYHEB_BASHRC"

# Append PyENV activation commands to pacyheb's .bashrc
append_to_bashrc 'export PATH="$HOME/.pyenv/bin:$PATH"' "$PACYHEB_BASHRC"
append_to_bashrc 'eval "$(pyenv init --path)"' "$PACYHEB_BASHRC"
append_to_bashrc 'eval "$(pyenv init -)"' "$PACYHEB_BASHRC"
append_to_bashrc 'eval "$(pyenv virtualenv-init -)"' "$PACYHEB_BASHRC"

# Change ownership of .bashrc to pacyheb
sudo chown pacyheb:pacyheb "$PACYHEB_BASHRC"

# Print completion message
echo "NVM and PyENV activation commands have been appended to pacyheb's .bashrc."