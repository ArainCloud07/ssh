#!/bin/bash
# ==================================================
# Arain Nodes - Secure SSH + Advanced Dynamic MOTD
# ==================================================

clear
echo -e "\033[1;36m🔐 Secure SSH FIXER\033[0m"
echo -e "\033[1;37m---------------------------------------\033[0m"
sleep 1


echo -e "\033[1;34m▶ Updating SSH configuration...\033[0m"

sudo bash -c 'cat <<EOF > /etc/ssh/sshd_config
# SSH LOGIN SETTINGS
PasswordAuthentication yes
PermitRootLogin yes
PubkeyAuthentication no
ChallengeResponseAuthentication no
UsePAM yes

# SECURITY IMPROVEMENTS
X11Forwarding no
AllowTcpForwarding yes

# SFTP
Subsystem sftp /usr/lib/openssh/sftp-server
EOF'

if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✔ SSH configuration applied successfully!\033[0m"
else
    echo -e "\033[1;31m✘ Failed to update SSH configuration!\033[0m"
fi

echo -e "\033[1;34m▶ Restarting SSH service...\033[0m"
sudo systemctl restart ssh || sudo service ssh restart
echo -e "\033[1;32m✔ SSH restarted successfully!\033[0m"
sleep 1

echo -e "\n\033[1;33m🔑 Please set ROOT password below 👇\033[0m"
sudo passwd root

