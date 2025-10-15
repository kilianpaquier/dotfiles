#!/bin/sh

set -e

PORT=HIDDEN
USER=nonroot

if [ "$(whoami)" != "root" ]; then
  echo "script should only be run as 'root'"
  exit 2
fi

# install security tools
apt -y update
apt -y upgrade
apt -y install fail2ban rsyslog ufw zsh

# setup user
if ! cat /etc/passwd | awk -F ":" '{print $1}' | grep "$USER"; then
  adduser --disabled-password --shell /bin/zsh --home /home/$USER --comment "$USER" $USER
  usermod -aG adm,docker,plugdev,sudo $USER
fi

mkdir -p /home/$USER/.ssh
cat << EOF > /home/$USER/.ssh/authorized_keys
HIDDEN
EOF
chown $USER:$USER /home/$USER/.ssh -R

cat << EOF > /etc/sudoers.d/$USER
# Created by custom script on $(date)

$USER ALL=(ALL) NOPASSWD:ALL
EOF

# setup fail2ban rules
cat << EOF > /etc/fail2ban/jail.d/cloud-init.conf
# Created by custom script on $(date)

[sshd]
enabled  = true
port     = $PORT
filter   = sshd
maxretry = 3
findtime = 5m
bantime  = 30m
EOF

# setup ssh configuration
cat << EOF > /etc/ssh/sshd_config.d/cloud-init.conf
# Created by custom script on $(date)

AllowUsers $USER
AuthorizedKeysFile .ssh/authorized_keys
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no
MaxAuthTries 3
PasswordAuthentication no
PermitRootLogin no
Port $PORT
EOF

# apply more strict firewall rules
ufw default deny incoming
ufw default allow outgoing

ufw allow $PORT/tcp
ufw limit $PORT/tcp

ufw allow in on docker0 to any port 80,443 proto tcp
ufw allow out on docker0

# enable firewall
ufw --force enable

# restart appropriate services
systemctl restart fail2ban sshd
