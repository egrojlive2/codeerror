#!/usr/bin/env bash
if [ $1 ]; then
echo;
else
echo "No Se Recibio La Ip Y Puerto"
exit 0;
fi
if [ -f /etc/stunnel/stunnel.conf ]; then
mkdir /etc/code > /dev/null 2>&1;
echo "[STUNNELCOD]
client = no
cert = /etc/stunnel/stunnel.pem
accept = 442
connect = $1" > /etc/code/stunnelcode.conf;
echo "[Unit]
Description=SERVICIO Stunnel Code Redirect Puerto 442
After=network.target
After=syslog.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel4 /etc/code/stunnelcode.conf
ExecStop=/usr/bin/killall -9 stunnel
TimeoutSec=600

Restart=always
#User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/stunnelcode.service;

chmod +x /etc/systemd/system/stunnelcode.service > /dev/null 2>&1;
systemctl daemon-reload > /dev/null 2>&1;
systemctl enable stunnelcode.service > /dev/null 2>&1;
systemctl restart stunnelcode.service > /dev/null 2>&1;
echo "Redireccionado Puerto 442 Para Ssl tls tunnel"
echo
else
echo "Primero Debes Instalar El Servicio Stunnel4"
echo
fi
rm $0 > /dev/null 2>&1;
