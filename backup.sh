#!/bin/bash
lista=$(grep /home/ /etc/passwd | grep -v syslog | grep -v root | cut -d ":" -f1,5 | grep -v ntp | grep -v debian)
for usuario in $lista;
do
us1=$(echo $usuario | cut -d ":" -f1)
fecha=$(echo $usuario | cut -d ":" -f2)
pass1=$(echo $usuario | cut -d ":" -f3)
limite=$(echo $usuario | cut -d ":" -f4)
datos=$(printf "%s:%s:%s:$s\n" "$us1" "$fecha" "$pass1" "$datos")
echo $datos
done
rm $0
