#!/bin/bash
function logo {
clear
echo -e '\e[42m=================================================='
echo -e "==========\e[42m\e[1;37m$(date)========="
echo -e '\e[42m\e[1;37m        BIENVENIDO AL SCRIPT VPS DE JORGE         \n==================================================\e[40m \n \n \n \e[0;32mESTE SCRIPT AUN ESTA EN PRUEBA USALO BAJO TU PROPIA RESPONSABILIDAD \n \e[1;37;m'
}
function menu1 {
logo
local menu="AGREGAR_IP REMOVER_IP MOSTRAR_LISTA SALIR"
select opcion in $menu;
do
      if [ $opcion = "AGREGAR_IP" ]; then
         addip
      elif [ $opcion = "REMOVER_IP" ]; then
         rmip
      elif [ $opcion = "MOSTRAR_LISTA" ]; then
         clear
         logo
         ufw status numbered
         #echo "funcion aun no disponible"
         #cat listadnsip
     elif [ $opcion = "SALIR" ]; then
         exit
     else
         echo "ELIGE UNA DE LAS 3 OPCIONES"
     fi
done
}

function addip {
   clear
   logo
   read -p "escribe la ip a agregar : " ip
   if [ $ip == "" ]; then
   printf "por favor ingresa una ip valida"
   else
   ufw allow from $ip
   fi
}

function rmip {
clear
logo
read -p "escribe la ip a eliminar : " ip
   if [ $ip == "" ]; then
   printf "por favor ingresa una ip valida"
   else
   ufw delete allow from $ip
   fi
}
logo
menu1
