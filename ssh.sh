#!/bin/bash
# ==================================================
# Arain Nodes - Secure SSH + Advanced Dynamic MOTD
# ==================================================

clear
echo -e "\033[1;36m🔐 Galaxy Host - Secure SSH & MOTD Setup\033[0m"
echo -e "\033[1;37m---------------------------------------\033[0m"
sleep 1

# ===============================
# SSH CONFIGURATION
# ===============================
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

# ===============================
# MOTD SETUP
# ===============================
echo -e "\033[1;34m▶ Installing Advanced MOTD...\033[0m"

# Disable default MOTD
chmod -x /etc/update-motd.d/* 2>/dev/null

# Create Arain Nodes MOTD
cat << 'EOF' > /etc/update-motd.d/00-galaxyhost
#!/bin/bash

# Colors
CYAN="\e[38;5;45m"
GREEN="\e[38;5;82m"
YELLOW="\e[38;5;220m"
BLUE="\e[38;5;51m"
RESET="\e[0m"

# Stats
LOAD=$(uptime | awk -F 'load average:' '{ print $2 }' | awk '{ print $1 }')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_PERC=$((MEM_USED * 100 / MEM_TOTAL))
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_PERC=$(df -h / | awk 'NR==2 {print $5}')
PROC=$(ps aux | wc -l)
USERS=$(who | wc -l)
IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p | sed 's/up //')

echo -e "${red}"
echo -e " ██████╗  █████╗ ██╗      █████╗ ██╗  ██╗██╗   ██╗    ██╗  ██╗ ██████╗ ███████╗████████╗"
echo -e "██╔════╝ ██╔══██╗██║     ██╔══██╗╚██╗██╔╝╚██╗ ██╔╝    ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝"
echo -e "██║  ███╗███████║██║     ███████║ ╚███╔╝  ╚████╔╝     ███████║██║   ██║███████╗   ██║   "
echo -e "██║   ██║██╔══██║██║     ██╔══██║ ██╔██╗   ╚██╔╝      ██╔══██║██║   ██║╚════██║   ██║   "
echo -e "╚██████╔╝██║  ██║███████╗██║  ██║██╔╝ ██╗   ██║       ██║  ██║╚██████╔╝███████║   ██║   "
echo -e " ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   "
echo -e "${RESET}"

echo -e "${GREEN} Welcome to Galaxy Host Datacenter 🚀 ${RESET}\n"

echo -e "${BLUE}📊 System Information:${RESET} ($(date))\n"
printf "  ${YELLOW}CPU Load     :${RESET} %s\n" "$LOAD"
printf "  ${YELLOW}Memory Usage :${RESET} %sMB / %sMB (%s%%)\n" "$MEM_USED" "$MEM_TOTAL" "$MEM_PERC"
printf "  ${YELLOW}Disk Usage   :${RESET} %s / %s (%s)\n" "$DISK_USED" "$DISK_TOTAL" "$DISK_PERC"
printf "  ${YELLOW}Processes    :${RESET} %s\n" "$PROC"
printf "  ${YELLOW}Users Logged :${RESET} %s\n" "$USERS"
printf "  ${YELLOW}IP Address   :${RESET} %s\n" "$IP"
printf "  ${YELLOW}Uptime       :${RESET} %s\n\n" "$UPTIME"

echo -e "${CYAN}Support: support@galaxyhost.site${RESET}"
echo -e "Website: ${BLUE}galaxyhost.site${RESET}"
echo -e "${GREEN}Power • Performance • Stability 💪${RESET}"
EOF

chmod +x /etc/update-motd.d/00-galaxyhost

echo -e "\033[1;32m✔ Advanced MOTD Installed Successfully!\033[0m"
sleep 1

# ===============================
# FINAL
# ===============================
clear
echo -e "\033[1;32m🎉 Galaxy Host SSH & MOTD Setup Completed!\033[0m"
echo -e "\033[1;37m📌 Reconnect SSH to see the new MOTD.\033[0m"

echo -e "\n\033[1;33m🔑 Please set ROOT password below 👇\033[0m"
sudo passwd root

echo -e "\n\033[1;36m✨ Welcome to Galaxy Host – Enjoy your server! 🚀\033[0m"
