#!/bin/bash
lista=$1
if [ -d /etc/code/limite ]; then
for usuario in $lista;
do
us1=$(echo $usuario | cut -d ":" -f1)
fecha=$(echo $usuario | cut -d ":" -f2)
pass1=$(echo $usuario | cut -d ":" -f3)
limite=$(echo $usuario | cut -d ":" -f4)
pkill -u $us1 > /dev/null 2>&1;
useradd $us1 > /dev/null 2>&1;
if [ $pass1 ]; then
echo "$us1:$pass1" | chpasswd;
fi
if [ $fecha ]; then
chage -E $fecha $us1;
usermod -c $fecha $us1 > /dev/null 2>&1;
else
fecha=''
fi
if [ $limite ]; then
limitar $us1 $limite
else
limite=0
fi
done

else
echo "Primero Debes De Actualizar Los Scripts"
fi
