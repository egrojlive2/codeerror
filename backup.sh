#!/bin/bash
lista=$(grep /home/ /etc/passwd | grep -v syslog | grep -v root | cut -d ":" -f1,5 | grep -v ntp | grep -v debian| sed "s/,/:/g"| sed "s/ /$/g")
for usuario in $lista;
do
us1=$(echo $usuario | cut -d ":" -f1)
fecha=$(echo $usuario | cut -d ":" -f2)
pass1=$(echo $usuario | cut -d ":" -f3)
limite=$(echo $usuario | cut -d ":" -f6)
echo "$us1:$fecha:$pass1::$limite"
done
rm $0
