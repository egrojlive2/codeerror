#!/bin/bash
if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  rm $0 > /dev/null 2>&1
  exit
fi
lista=$1
if [ -d /etc/code/limite ]; then
for usuario in $lista;
do
us1=$(echo $usuario | cut -d ":" -f1)
fecha=$(echo $usuario | cut -d ":" -f2)
pass1=$(echo $usuario | cut -d ":" -f3)
limite=$(echo $usuario | cut -d ":" -f5)
pkill -u $us1 > /dev/null 2>&1;
useradd $us1 > /dev/null 2>&1;
if [ $pass1 ]; then
echo "$us1:$pass1" | chpasswd
chfn -r $pass1 $us1 > /dev/null 2>&1;
fi
if [ $fecha ]; then
chage -E $fecha $us1;
chfn -f $fecha $us1 > /dev/null 2>&1;
else
fecha=''
fi
if [ $limite ]; then
chfn -o $limite $us1 > /dev/null 2>&1;
chmod 777 /usr/bin/limitar > /dev/null 2>&1;
limitar $us1 $limite;
fi
done

else
echo "Primero Debes De Actualizar Los Scripts"
fi
rm $0 > /dev/null 2>&1
