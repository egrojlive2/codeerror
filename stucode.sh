#!/usr/bin/env bash
if [ $1 ]; then
echo;
else
echo "No Se Recibio La Ip Y Puerto"
exit 0;
fi
if [ -f /etc/stunnel/stunnel.conf ]; then
echo "[STUNNELCODE]
client = yes
cert = /etc/stunnel/stunnel.pem
accept = 127.0.0.1:442
connect = $1" > /etc/code/stunnelcode.conf;
mkdir /etc/code > /dev/null 2>&1;
echo "[Unit]
Description=SERVICIO Stunnel Code Redirect Puerto 442
After=network.target

[Service]
Type=ilde
ExecStart=/usr/bin/stunnel4 /etc/code/stunnelcode.conf
User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/stunnelcode.service;


chmod +x /etc/systemd/system/stunnelcode.service > /dev/null 2>&1;
systemctl daemon-reload > /dev/null 2>&1;
systemctl enable stunnelcode.service > /dev/null 2>&1;
systemctl restart stunnelcode.service > /dev/null 2>&1;
else
echo "Primero Debes Instalar El Servicio Stunnel4"
fi
rm $0 > /dev/null 2>&1;
