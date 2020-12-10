#!/bin/bash
if [[ "$USER" != 'root' ]]; then
  echo "Este Script Solo Funciona Para Usuarios root"
  exit
fi
rm ONLINE > /dev/null 2>&1;rm ssh.txt > /dev/null 2>&1;rm login-db.txt > /dev/null 2>&1

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
#NUM2=`ps aux | grep sshd | grep -v root | grep -v debian | grep -v admin | wc -l`;
tot=0
#echo '<font color=\"#FFBF38\">Usuarios Openssh '$((NUM2))'</font><br>'
#echo "$data"
for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM2=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        total=$(cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}' | grep "$USER" | wc -l) 
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM2 -eq 1 ]; then
                echo "$USER" >> ssh.txt;
                ((tot ++))
                #echo "[TOTAL en OpenSSH]: $NUM2";
        fi
done
echo "<font color=\"#FFBF38\">USUARIOS SSH $tot</font><br>"
if [ -f ssh.txt ]; then
echo '<font color='green'>Conexiones - Usuarios</font><br>';
sed 's/\\s/\\n/g' ssh.txt | sort | uniq  -c | sort -n | sed 's/$/<br>/'
fi
rm $0
