#!/bin/bash

if cat /etc/*release | grep DISTRIB_DESCRIPTION | grep \"Ubuntu 14.04\"; then
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
# Install OpenVPN
apt-get -y install openvpn easy-rsa openssl iptables
cp -r /usr/share/easy-rsa/ /etc/openvpn
mkdir /etc/openvpn/easy-rsa/keys
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="@mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU="MyOrganizationalUnit"|export KEY_OU="mx"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME="EasyRSA"|export KEY_NAME="cod3err0r"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU=cod3err0r|' /etc/openvpn/easy-rsa/vars

# Create Diffie-Helman Pem
openssl dhparam -out /etc/openvpn/dh2048.pem 2048

# Create PKI
cd /etc/openvpn/easy-rsa
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*

# Create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server

# Setting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client


# cp /etc/openvpn/easy-rsa/keys/{server.crt,server.key,ca.crt} /etc/openvpn
cd
cp /etc/openvpn/easy-rsa/keys/server.crt /etc/openvpn/server.crt
cp /etc/openvpn/easy-rsa/keys/server.key /etc/openvpn/server.key
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/ca.crt

# Setting Server
cd /etc/openvpn/
wget "https://github.com/egrojlive/codeerror/raw/master/server.conf"

#Create OpenVPN Config
cd
wget "https://github.com/egrojlive/codeerror/raw/master/client.ovpn"
cp client.ovpn clienttcp.ovpn
sed -i $MYIP2 clienttcp.ovpn;
echo '<ca>' >> clienttcp.ovpn
cat /etc/openvpn/ca.crt >> clienttcp.ovpn
echo '</ca>' >> clienttcp.ovpn
#cd /home/vps/public_html/
#tar -czf /home/vps/public_html/openvpn.tar.gz client.ovpn
#tar -czf /home/vps/public_html/client.tar.gz client.ovpn
#cd

# Restart OpenVPN
/etc/init.d/openvpn restart
service openvpn start
service openvpn status

# Setting USW
apt-get install ufw
ufw allow ssh
ufw allow 4444/tcp
sed -i 's|DEFAULT_INPUT_POLICY="DROP"|DEFAULT_INPUT_POLICY="ACCEPT"|' /etc/default/ufw
sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|' /etc/default/ufw
cd /etc/ufw/
wget "https://github.com/egrojlive/codeerror/raw/master/before.rules"
cd
ufw enable
ufw status
ufw disable

# set ipv4 forward
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
exit
fi



echo "VERIFICANDO REQUERIMIENTOS"
TCP_SERVICE_AND_CONFIG_NAME="openvpn_tcp"
UDP_SERVICE_AND_CONFIG_NAME="openvpn_udp"
###############################################################
if [[ "$USER" != 'root' ]]; then
  echo "Sorry, you need to run this as root"
  exit
fi
###############################################################
if [[ ! -e /dev/net/tun ]]; then
  echo "TUN/TAP is not available"
  exit
fi
###############################################################
if grep -qs "CentOS release 5" "/etc/redhat-release"; then
  echo "CentOS 5 is too old and not supported"
  exit
fi
###############################################################
if [[ -e /etc/debian_version ]]; then
  OS=debian
  RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
  OS=centos
  RCLOCAL='/etc/rc.d/rc.local'
  # Needed for CentOS 7
  chmod +x /etc/rc.d/rc.local
else
  echo "ESTE SCRIPT SOLO FUNCIONA EN : Debian Y Ubuntu"
  exit
fi
###############################################################
newclienttcp () {
  # This function is used to create tcp client .ovpn file
  cp /etc/openvpn/clienttcp-common.txt ~/"$1tcp.ovpn"
  echo "<ca>" >> ~/"$1tcp.ovpn"
  cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/"$1tcp.ovpn"
  echo "</ca>" >> ~/"$1tcp.ovpn"
  echo "<cert>" >> ~/"$1tcp.ovpn"
  cat /etc/openvpn/easy-rsa/pki/issued/"$1.crt" >> ~/"$1tcp.ovpn"
  echo "</cert>" >> ~/"$1tcp.ovpn"
  echo "<key>" >> ~/"$1tcp.ovpn"
  cat /etc/openvpn/easy-rsa/pki/private/"$1.key" >> ~/"$1tcp.ovpn"
  echo "</key>" >> ~/"$1tcp.ovpn"
  if [ "$TLS" = "1" ]; then  #check if TLS is selected to add a TLS static key
    echo "key-direction 1" >> ~/"$1tcp.ovpn"
    echo "<tls-auth>" >> ~/"$1tcp.ovpn"
    cat /etc/openvpn/easy-rsa/pki/private/ta.key >> ~/"$1tcp.ovpn"
    echo "</tls-auth>" >> ~/"$1tcp.ovpn"
  fi
  if [ $TLSNEW = 1 ]; then
    echo "--tls-version-min 1.2" >> ~/"$1.ovpn"
  fi
}
###############################################################
function version_gt() {
   test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1";
    }
###############################################################
    IP=$(wget -qO- ipv4.icanhazip.com)
###############################################################
  clear
  echo "listening to. " $IP
  #read -p "IP address: " -e -i $IP IP
  echo ""
  #read -p "Do you want to run a UDP server [y/n]: " -e -i y UDP
  TCP=1
  #read -p "Do you want to run a TCP server [y/n]: " -e -i n TCP
  ###############################################################
  clear
  #read -p "What UDP port do you want to run OpenVPN on?: " -e -i 1194 PORT
  echo "PUERTO DE ESCUCHA : 4444"
  PORTTCP=4444
  #read -p "What TCP port do you want to run OpenVPN on?: " -e -i 443 PORTTCP
   echo "USANDO KEY 2048 BITS"
  KEYSIZE=2048
  DIGEST=SHA256
  #read -p "Digest Size [1-2]: " -e -i 1 DIGEST
###############################################################
  AES=0
        grep -q aes /proc/cpuinfo #Check for AES-NI availability
        if [[ "$?" -eq 0 ]]; then
         AES=1
        fi

   if [[ "$AES" -eq 1 ]]; then
         echo "Your CPU supports AES-NI instruction set."
   fi
echo "USANDO CIRADO : AES-256-CBC"
CIPHER=AES-256-CBC
echo "USANDO TLS-AUTH"
TLS=1
#read -p "Do you want to use additional TLS authentication [y/n]: " -e -i y TLS
INTERNALNETWORK=1
echo "USANDO DNS 1.1.1.1 - 9.9.9.9"
#read -p "Allow internal networking [y/n]: " -e -i y INTERNALNETWORK
DNSRESOLVER=0
ANTIVIR=0
###############################################################
if [ "$DNSRESOLVER" = 0 ]; then
DNS=1
#read -p "DNS [1-6]: " -e -i 1 DNS
CLIENT='client'
#read -p "Client name: " -e -i client CLIENT
if [[ "$OS" = 'debian' ]]; then


apt-get update -qq -y
apt-get install openvpn iptables openssl -y -qq
apt-get install build-essential libssl-dev liblzo2-dev libpam0g-dev easy-rsa -y
ovpnversion=$(openvpn --status-version | grep -o "([0-9].*)" | sed 's/[^0-9.]//g')
if version_gt $ovpnversion "2.3.3"; then
echo "Your OpenVPN version is $ovpnversion and it supports"
echo "NOTE: Your client also must use version 2.3.3 or newer"
TLSNEW=1
#read -p "Force TLS 1.2 [y/n]: " -e -i n TLSNEW
fi

###############################################################
if [[ -d /etc/openvpn/easy-rsa/ ]]; then
  rm -rf /etc/openvpn/easy-rsa/
fi
# Get easy-rsa
wget --no-check-certificate -O ~/EasyRSA-3.0.1.tgz https://github.com/OpenVPN/easy-rsa/releases/download/3.0.1/EasyRSA-3.0.1.tgz > /dev/null 2>&1
tar xzf ~/EasyRSA-3.0.1.tgz -C ~/
mkdir /etc/openvpn
mv ~/EasyRSA-3.0.1/ /etc/openvpn/EasyRSA-3.0.1
mv /etc/openvpn/EasyRSA-3.0.1/ /etc/openvpn/easy-rsa/
chown -R root:root /etc/openvpn/easy-rsa/
rm -rf ~/EasyRSA-3.0.1.tgz
cd /etc/openvpn/easy-rsa/
# Create the PKI, set up the CA, the DH params and the server + client certificates
./easyrsa init-pki
cp vars.example vars
sed -i 's/#set_var EASYRSA_KEY_SIZE 2048/set_var EASYRSA_KEY_SIZE   '$KEYSIZE'/' vars
./easyrsa --batch build-ca nopass
./easyrsa gen-dh
./easyrsa build-server-full server nopass
./easyrsa build-client-full "$CLIENT" nopass
./easyrsa gen-crl
openvpn --genkey --secret /etc/openvpn/easy-rsa/pki/private/ta.key
cp pki/ca.crt pki/private/ca.key pki/dh.pem pki/issued/server.crt pki/private/server.key /etc/openvpn
echo "GENERANDO CERTIFICADO"
echo "port $PORTTCP
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
push \"register-dns\"
topology subnet
server 10.9.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
cipher AES-256-CBC
user nobody
group nogroup
client-cert-not-required
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
sndbuf 0
rcvbuf 0
push \"redirect-gateway def1 bypass-dhcp\"
--tls-auth /etc/openvpn/easy-rsa/pki/private/ta.key 0
push \"dhcp-option DNS 1.1.1.1\"
push \"dhcp-option DNS 9.9.9.9\"
keepalive 10 120
comp-lzo
persist-key
persist-tun
status openvpn-status.log
verb 3
crl-verify /etc/openvpn/easy-rsa/pki/crl.pem
client-to-client
" > /etc/openvpn/$TCP_SERVICE_AND_CONFIG_NAME.conf

  sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
  sed -i " 5 a\echo 1 > /proc/sys/net/ipv4/ip_forward" $RCLOCAL    # Added for servers that don't read from sysctl at startup

  echo 1 > /proc/sys/net/ipv4/ip_forward
  # Set NAT for the VPN subnet
     if [ "$INTERNALNETWORK" = 1 ]; then
    if [ "$TCP" = 1 ]; then
      iptables -t nat -A POSTROUTING -s 10.9.0.0/24 ! -d 10.9.0.0/24 -j SNAT --to $IP
      sed -i "1 a\iptables -t nat -A POSTROUTING -s 10.9.0.0/24 ! -d 10.9.0.0/24 -j SNAT --to $IP" $RCLOCAL
      fi
     else
    if [ "$TCP" = 1 ]; then
      iptables -t nat -A POSTROUTING -s 10.9.0.0/24  ! -d 10.9.0.1 -j SNAT --to $IP #This line and the next one are added for tcp server instance
      sed -i "1 a\iptables -t nat -A POSTROUTING -s 10.9.0.0/24 -j SNAT --to $IP" $RCLOCAL
    fi
   fi

  if iptables -L | grep -q REJECT; then
    if [ "$TCP" = 1 ]; then
      iptables -I INPUT -p udp --dport $PORTTCP -j ACCEPT #This line and next 5 lines have been added for tcp support
      iptables -I FORWARD -s 10.9.0.0/24 -j ACCEPT
      iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
      sed -i "1 a\iptables -I INPUT -p tcp --dport $PORTTCP -j ACCEPT" $RCLOCAL
      sed -i "1 a\iptables -I FORWARD -s 10.9.0.0/24 -j ACCEPT" $RCLOCAL
      sed -i "1 a\iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" $RCLOCAL
    fi
  fi

  if [ "$TCP" = 1 ]; then
    echo "[Unit]
#Created by openvpn-install-advanced (https://github.com/pl48415/openvpn-install-advanced)
Description=OpenVPN Robust And Highly Flexible Tunneling Application On <server>
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/var/run/openvpn/$TCP_SERVICE_AND_CONFIG_NAME.pid
ExecStart=/usr/sbin/openvpn --daemon --writepid /var/run/openvpn/$TCP_SERVICE_AND_CONFIG_NAME.pid --cd /etc/openvpn/ --config $TCP_SERVICE_AND_CONFIG_NAME.conf

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$TCP_SERVICE_AND_CONFIG_NAME.service
    if pgrep systemd-journal; then
      sudo systemctl enable $TCP_SERVICE_AND_CONFIG_NAME.service
    fi
  fi

  if pgrep systemd-journal; then
    sudo systemctl start openvpn.service
  else
    if [[ "$OS" = 'debian' ]]; then
      /etc/init.d/openvpn start
    else
      service openvpn start
    fi
  fi
service openvpn_tcp restart
  EXTERNALIP=$(wget -qO- ipv4.icanhazip.com)
if [ "$TCP" = 1 ]; then
echo "client
cipher $CIPHER
auth-user-pass
dev tun
proto tcp
remote $IP $PORTTCP
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
comp-lzo
verb 3
sndbuf 0
rcvbuf 0
" > /etc/openvpn/clienttcp-common.txt
newclienttcp "$CLIENT"
  fi
  if [ "$TCP" = 1 ]; then
  echo "Your TCP client config is available at ~/${CLIENT}tcp.ovpn"
  fi
fi
if [ "$DNSRESOLVER" = 1 ]; then
service unbound restart
service openvpn_tcp restart
fi
fi
service openvpn_tcp restart
