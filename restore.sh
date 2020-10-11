#!/bin/bash
#chfn -f 2020/08/12 -h casa -r 3131003801 -w oficina -o mas jorge
#jorge:2020/08/12,3131003801,oficina,casa,mas
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
chfn -f $fecha $us1
else
fecha=''
fi
if [ $limite ]; then
chfn -w $limite $us1
limitar $us1 $limite
else
limite=0
fi
done

else
echo "Primero Debes De Actualizar Los Scripts"
fi
