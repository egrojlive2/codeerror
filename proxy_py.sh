#!/usr/bin/env bash

if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  rm $0 > /dev/null 2>&1;
  exit
fi
puerto_primero='80'
puerto_segundo='8080'

if [ $1 ]; then
puerto_primero=$1;
fi
if [ $2 ]; then
puerto_segundo=$2;
fi

echo "Instalando Proxy En Puertos EL $puerto_primero Y $puerto_segundo"
mkdir /etc/code > /dev/null 2>&1;
apt-get install python -y > /dev/null 2>&1;
apt install curl -y > /dev/null 2>&1;
if [ -f /etc/code/proxy.py ]; then
systemctl stop proxypy.service > /dev/null 2>&1;
systemctl stop proxyvpnpy.service > /dev/null 2>&1;
rm /etc/code/proxy.py > /dev/null 2>&1;
rm /etc/code/proxyvpn.py > /dev/null 2>&1;
wget https://github.com/egrojlive/codeerror/raw/master/pr_py.py -O /etc/code/proxy.py > /dev/null 2>&1;
chmod +x /etc/code/proxy.py > /dev/null 2>&1;
cp /etc/code/proxy.py /etc/code/proxyvpn.py;
chmod +x /etc/code/proxyvpn.py > /dev/null 2>&1;
else
mkdir /etc/code > /dev/null 2>&1;
wget https://github.com/egrojlive/codeerror/raw/master/pr_py.py -O /etc/code/proxy.py > /dev/null 2>&1;
cp /etc/code/proxy.py /etc/code/proxyvpn.py;
chmod +x /etc/code/proxy.py > /dev/null 2>&1;
chmod +x /etc/code/proxyvpn.py > /dev/null 2>&1;
fi

echo "[Unit]
Description=SERVICIO proxy python en escucha puerto $puerto_primero
After=network.target

[Service]
Type=ilde
ExecStart=/usr/bin/python /etc/code/proxy.py $puerto_primero
User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/proxypy.service;

echo "[Unit]
Description=SERVICIO proxy python para OPENVPN en escucha puerto $puerto_segundo
After=network.target

[Service]
Type=ilde
ExecStart=/usr/bin/python /etc/code/proxyvpn.py $puerto_segundo
User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/proxyvpnpy.service;
sed -i "s/80/$puerto_primero/g" /etc/code/proxy.py > /dev/null 2>&1;
sed -i "s/80/$puerto_segundo/g" /etc/code/proxyvpn.py > /dev/null 2>&1;

chmod +x /etc/systemd/system/proxypy.service > /dev/null 2>&1;
chmod +x /etc/systemd/system/proxyvpnpy.service > /dev/null 2>&1;
systemctl daemon-reload > /dev/null 2>&1;
systemctl enable proxypy.service > /dev/null 2>&1;
systemctl enable proxyvpnpy.service > /dev/null 2>&1;
systemctl restart proxypy.service > /dev/null 2>&1;
systemctl restart proxyvpnpy.service > /dev/null 2>&1;
rm proxy.sh > /dev/null 2>&1;
rm $0 > /dev/null 2>&1;
