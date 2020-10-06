#!/bin/bash
function ssl_info(){
        if [ -f /etc/stunnel/stunnel.conf ]; then
    puertosssl=$(cat /etc/stunnel/stunnel.conf | grep -i accept | awk '{print $3}' | sort)
    inform=$(service stunnel4 status);
    if [[ $inform =~ "Active: active" ]]; then
    echo "El Servicio stunnel esta Corriendo Correctamente\n"
    else
    echo "Hay Un Error El Servicio"
    fi
    for p1 in $puertosssl
    do
    echo "puerto $p1"
        done
        else
                echo "Stunnel No Se Encuentra Instalado"
    fi
    unset puertosssl
    unset p1
}
function squid_info(){
if [ -f /etc/squid/squid.conf ]; then
        puertosquid=$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | sort)
inform=$(service squid status);
    if [[ $inform =~ "Active: active" ]]; then
    echo "El Servicio squid Esta Corriendo Correctamente\n"
    else
    echo "Hay Un Error En El Servicio\n"
    fi
for p2 in $puertosquid
do
echo "puerto $p2"
        done
elif [ -f /etc/squid3/squid.conf ]; then
                        puertosquid=$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}' | sort)
                        inform=$(service squid3 status);
    if [[ $inform =~ "Active: active" ]]; then
    echo "El Servicio squid Esta Corriendo Correctamente"
    else
    echo "Hay Un Error En El Servicio"
    fi
for p2 in $puertosquid
do
echo "puerto $p2"
        done
else
        echo "El Servicio Squid No Se Encuentra Instalado"
        return
fi
unset puertosquid
    unset p2
}
function dropbear_info(){
        if [ -f /etc/default/dropbear ]; then
        puertodropbear=$(cat /etc/default/dropbear | grep -i DROPBEAR_PORT)
        inform=$(service dropbear status);
    if [[ $inform =~ "Active: active" ]]; then
    echo "Servicio dropbear Corriendo Correctamente"
    else
    echo "Error En El Servicio dropbear"
    fi
echo "$puertodropbear"
else
        echo "El Servicio Dropbear No Se Encuentra Instalado"
fi
unset puertodropbear
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
