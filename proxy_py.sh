#!/usr/bin/env bash
echo "INSTALANDO PROXY PYTHON"
echo
echo
if [ -f /etc/code/proxy.py ]; then
chmod +x /etc/code/proxy.py > /dev/null 2>&1;
else
mkdir /etc/code > /dev/null 2>&1;
wget https://github.com/egrojlive/codeerror/raw/master/pr_py.py -O /etc/code/proxy.py > /dev/null 2>&1;
chmod +x /etc/code/proxy.py > /dev/null 2>&1;
fi
sed -i "s/8080/8081/g" /etc/default/sslh > /dev/null 2>&1;
service sslh restart > /dev/null 2>&1;

echo "[Unit]
Description=SERVICIO proxy python en escucha puerto 8081

[Service]
Type=ilde
ExecStart=/usr/bin/python /etc/code/proxy.py
User=root
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/proxypy.service;

chmod +x /etc/systemd/system/proxypy.service > /dev/null 2>&1;
systemctl daemon-reload > /dev/null 2>&1;
systemctl restart proxypy.service > /dev/null 2>&1;
rm $0
