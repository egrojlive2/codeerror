#!/bin/bash
eliminados=0
lista=""
hoy=$(date -d "-1 day" +'%Y%m%d')
registros=$(grep /home/ /etc/passwd | grep -v syslog | grep -v root | cut -d ":" -f1 | grep -v ntp | grep -v debian)


for PID in $registros
do

usuario=$PID;        

fecha_cad=$(chage -l "$usuario" | grep -i "Account" | awk -F: '{print $2}' | sed 's/,//g' | cut -d " " -f2,3,4 | awk -F: '{print $1}')
a_c=$(echo $fecha_cad | cut -d " " -f3)
m_c=$(echo $fecha_cad | cut -d " " -f1)
d_c=$(echo $fecha_cad | cut -d " " -f2)

fecha_cad=$(date -d "$d_c-$m_c-$a_c" +'%Y%m%d')

if [ $hoy -gt $fecha_cad ]; then
pkill -u $usuario
userdel $usuario
((eliminados ++))
fi
done
if [ $eliminados -eq 0 ];then
echo "NO HAY USUARIOS CADUCADOS"
else
echo "$eliminados"
fi
