# shellcheck shell=sh

set_hostname() {
  old=$(hostname)
  if [ "$old" = "{{ .machine.name }}" ]; then
    return 0
  fi

  if ! ignored /etc/hosts; then
    # hostnamectl leaves /etc/hosts alone, replace the whitespace-bounded old name
    hosts=$(sed -E "s#(^|[[:space:]])$old([[:space:]]|$)#\1{{ .machine.name }}\2#g" /etc/hosts)

    # /etc/hosts goes first, a refused hostnamectl leaves the hostname different and the next run retries
    sudo_write /etc/hosts "$hosts" || return 1
  fi

  ignored /etc/hostname || sudo_run hostnamectl set-hostname "{{ .machine.name }}"
}

set_timezone() {
  if [ "$(timedatectl show -p Timezone --value)" = "{{ .machine.timezone }}" ]; then
    return 0
  fi

  if ! sudo_run timedatectl set-timezone "{{ .machine.timezone }}"; then
    warn "timezone isn't {{ .machine.timezone }}, run as root: timedatectl set-timezone {{ .machine.timezone }}"
    return 0
  fi

  # long-running daemons cache the timezone, the cron unit is crond on Fedora and Arch
  for service in cron crond rsyslog; do
    systemctl is-active --quiet "$service" || continue
    if ! sudo_run systemctl restart "$service"; then
      warn "$service keeps the old timezone, run as root: systemctl restart $service"
    fi
  done
}

if [ -d /run/systemd/system ]; then
  if ! set_hostname; then
    warn "hostname isn't {{ .machine.name }}, run as root: hostnamectl set-hostname {{ .machine.name }}, and rename $old in /etc/hosts"
  fi

  ignored /etc/localtime || set_timezone
else
  warn "systemd isn't running, skipping hostname and timezone"
fi
