# shellcheck shell=sh

server_identity() {
  [ -d /run/systemd/system ] || {
    warn "systemd isn't running, skipping hostname and timezone"
    return 0
  }

  hostname=$(hostname)
  if [ "$hostname" != "{{ .machine.name }}" ]; then
    # hostnamectl leaves /etc/hosts alone, replace the whitespace-bounded old name
    sed -E "s#(^|[[:space:]])$hostname([[:space:]]|$)#\1{{ .machine.name }}\2#g" /etc/hosts | sudo tee /etc/hosts >/dev/null
    sudo hostnamectl set-hostname "{{ .machine.name }}"
  fi

  timezone=$(timedatectl show -p Timezone --value)
  if [ "$timezone" != "{{ .machine.timezone }}" ]; then
    sudo timedatectl set-timezone "{{ .machine.timezone }}"
    # long-running daemons cache the timezone, the cron unit is crond on Fedora and Arch
    for service in cron crond rsyslog; do
      ! systemctl is-active --quiet "$service" || sudo systemctl restart "$service"
    done
  fi
}
server_identity
