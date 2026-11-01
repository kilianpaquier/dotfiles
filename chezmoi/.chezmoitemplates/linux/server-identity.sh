# shellcheck shell=sh

hostname=$(hostname)
if [ "$hostname" != "{{ .machine.name }}" ]; then
  # hostnamectl leaves /etc/hosts alone, replace the whitespace-bounded old name
  sed -E "s#(^|\s)$hostname(\s|$)#\1{{ .machine.name }}\2#g" /etc/hosts | sudo tee /etc/hosts >/dev/null
  sudo hostnamectl set-hostname "{{ .machine.name }}"
fi

timezone=$(timedatectl show -p Timezone --value)
if [ "$timezone" != "{{ .machine.timezone }}" ]; then
  sudo timedatectl set-timezone "{{ .machine.timezone }}"
  # long-running daemons cache the timezone
  for service in cron rsyslog; do
    ! systemctl is-active --quiet "$service" || sudo systemctl restart "$service"
  done
fi
