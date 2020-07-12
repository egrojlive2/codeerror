#!/bin/bash
function ssl_info(){
	if [ -f /etc/stunnel/stunnel.conf ]; then
    puertosssl=$(cat /etc/stunnel/stunnel.conf | grep -i accept | awk '{print $3}' | sort)
    for p1 in $puertosssl
    do
    echo "puerto $p1"
	done
	else
		echo "Stunnel No Se Encuentra Instalado"
    fi
}
function squid_info(){
if [ -f /etc/squid/squid.conf ]; then
	puertosquid=$(cat /etc/squid/squid.conf | grep -i accept | awk '{print $2}' | sort)
elif [ -f /etc/squid3/squid.conf ]; then
			puertosquid=$(cat /etc/squid3/squid.conf | grep -i accept | awk '{print $2}' | sort)
else
	echo "El Servicio Squid No Se Encuentra Instalado"
	return
fi
	
for p2 in $puertosquid
do
echo "puerto $p2"
	done
}
function dropbear_info(){
	if [[ -f /etc/default/dropbear ]]; then
	puertodropbear=$(cat /etc/deault/dropbear | grep -i DROPBEAR_PORT)
echo "$puertodropbear"
else
	echo "El Servicio Dropbear No Se Encuentra Instalado"
fi
}
if [ $1 == "ssl" ]; then
    ssl_info
elif [ $1 == "squid" ]; then
	squid_info
elif [ $1 == "dropbear" ]; then
	dropbear_info
else
	echo "El Comando Es Incorrecto"
fi
