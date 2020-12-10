#!/bin/bash
if [ $USER != "root" ]; then
echo "Este Script Solo Funciona Con Usuario root";
exit 0;
fi
timedatectl set-timezone America/Mexico_City > /dev/null 2>&1;
eliminados=0
lista=""
hoy=$(date +'%Y%m%d')
registros=$(grep /home/ /etc/passwd | grep -v syslog | grep -v root | cut -d ":" -f1 | grep -v ntp | grep -v debian)


for PID in $registros
do

usuario=$PID;

fecha_cad=$(chage -l "$usuario" | grep -i "Account" | awk -F: '{print $2}' | sed 's/,//g' | cut -d " " -f2,3,4 | awk -F: '{print $1}')
if [[ $fecha_cad != *never* ]]; then
a_c=$(echo $fecha_cad | cut -d " " -f3)
m_c=$(echo $fecha_cad | cut -d " " -f1)
d_c=$(echo $fecha_cad | cut -d " " -f2)

fecha_cad=$(date -d "$d_c-$m_c-$a_c" +'%Y%m%d')

if [ $hoy -ge $fecha_cad ]; then
pkill -u $usuario
userdel $usuario
limpcron=$(cat /etc/crontab |grep -v "#$usuario#")
echo "$limpcron" > /etc/crontab
((eliminados ++))
fi
fi
done
if [ $eliminados -eq 0 ];then
echo "NO HAY USUARIOS CADUCADOS"
else
echo "$eliminados"
fi
