#!/usr/bin/env bash
#echo "INSTALANDO PROXY PYTHON"
#echo "PROXY SSH 8081"
#echo "PROXY OPENVPN 8082"
if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  rm $0 > /dev/null 2>&1;
  exit
fi
echo "<font color='green'>DISCULPA PERO LOS VERDADEROS PUERTOS DEL PROXY SON EL 80 Y 8080</font>"
mkdir /etc/code > /dev/null 2>&1;
apt-get install python -y > /dev/null 2>&1;
apt install curl -y > /dev/null 2>&1;
if [ -f /etc/code/proxy.py ]; then
rm /etc/code/proxy.py > /dev/null 2>&1;
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
#sed -i "s/8080/8081/g" /etc/default/sslh > /dev/null 2>&1;
#service sslh restart > /dev/null 2>&1;

echo "[Unit]
Description=SERVICIO proxy python en escucha puerto 80
After=network.target

[Service]
Type=ilde
ExecStart=/usr/bin/python /etc/code/proxy.py
User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/proxypy.service;

echo "[Unit]
Description=SERVICIO proxy python para OPENVPN en escucha puerto 8080
After=network.target

[Service]
Type=ilde
ExecStart=/usr/bin/python /etc/code/proxyvpn.py
User=root
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/proxyvpnpy.service;
sed -i "s/80/8080/g" /etc/code/proxyvpn.py > /dev/null 2>&1;
#sed -i "s/22/4444/g" /etc/code/proxyvpn.py > /dev/null 2>&1;

chmod +x /etc/systemd/system/proxypy.service > /dev/null 2>&1;
chmod +x /etc/systemd/system/proxyvpnpy.service > /dev/null 2>&1;
systemctl daemon-reload > /dev/null 2>&1;
systemctl enable proxypy.service > /dev/null 2>&1;
systemctl enable proxyvpnpy.service > /dev/null 2>&1;
systemctl restart proxypy.service > /dev/null 2>&1;
systemctl restart proxyvpnpy.service > /dev/null 2>&1;
rm proxy.sh > /dev/null 2>&1;
rm $0 > /dev/null 2>&1;
