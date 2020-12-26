#!/bin/bash
if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  exit
fi
mkdir -p /etc/code/limite
userrc=$(echo $1 |sed 's/@/aa/g' |sed 's/-/k/g' |sed 's/0/a/g' |sed 's/1/b/g' |sed 's/2/c/g' |sed 's/3/d/g' |sed 's/4/e/g' |sed 's/5/f/g' |sed 's/6/g/g' |sed 's/7/h/g' |sed 's/8/i/g' |sed 's/9/j/g')
limpcron=$(cat /etc/crontab |grep -v "#$1#")
echo "$limpcron" > /etc/crontab
echo "#!/usr/bin/env bash
function limpiar_usuarios(){
rm /tmp/sshpid$1
echo \$\"(ps -u $1 | grep sshd | awk '{print \$1}' | sed 's/ /$/g')\" >> /tmp/sshpid$1;
data=\$(ps aux | grep -i dropbear | awk '{print \$2}');
for PID in "\${data[@]}"
do
        n_USER=\$(cat /var/log/auth.log | grep -i dropbear | grep -i \"Password auth succeeded\" | grep \"dropbear\[\$PID\]\" | awk '{print \$10}' | sed \"s/'//g\");
        if [ \"\$n_USER\" = \"$1\" ]; then
                echo \"\$PID\" >> /tmp/sshpid$1;
        fi
done

l_tot=\$(cat /tmp/sshpid$1 |awk '{print \$1}' |wc -l);

if [ \"\$l_tot\" -gt \"$2\" ]; then
for pid in \$( seq $2 1 \$l_tot )
do
kill \$(head -n 1 /tmp/sshpid$1)
done
fi
unset data
unset n_USER
unset l_tot
}
unset userrc
unset limpcron
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
limpiar_usuarios;
sleep 2.5s;
" > /etc/code/limite/$1.sh
chmod a+x /etc/code/limite/$1.sh 2>/dev/null
echo "*/1 * * * * root /etc/code/limite/$1.sh #$1#" >> /etc/crontab
echo "Usuario: $1 Limite: $2 Aplicado" 
echo "$2" > /etc/code/limite/$1
