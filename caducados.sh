#!/bin/bash
remover_drop(){
buscar=$1
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
for PID in "${data[@]}"
do
        NUM1=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
        USER2=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}' | sed "s/'//g"`;
        IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
        if [ $NUM1 -eq 1 ]; then
                if [ "$buscar" == "$USER2" ]; then
                kill $PID > /dev/null 2>&1;
                fi
        fi
done
}

if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  exit
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
remover_drop "$usuario";
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
