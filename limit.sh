#!/bin/bash
mkdir -p /etc/code/limite
userrc=$(echo $1 |sed 's/@/aa/g' |sed 's/-/k/g' |sed 's/0/a/g' |sed 's/1/b/g' |sed 's/2/c/g' |sed 's/3/d/g' |sed 's/4/e/g' |sed 's/5/f/g' |sed 's/6/g/g' |sed 's/7/h/g' |sed 's/8/i/g' |sed 's/9/j/g')
limpcron=$(cat /etc/crontab |grep -v "#$1#")
echo "$limpcron" > /etc/crontab
echo "#!/bin/sh
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
sleep 2.5s
if [ \$(ps -u $1 |grep sshd |wc -l) -gt $2 ]; then ps -u $1 |grep sshd |awk '{print \$1}' > /tmp/sshpid$1; sshpid$userrc=\$(cat -n /tmp/sshpid$1 |awk '\$1 > $2 {print \$2}'); kill \$sshpid$userrc; fi
exit
" > /etc/code/limite/$1.sh
chmod a+x /etc/code/limite/$1.sh 2>/dev/null
echo "*/1 * * * * root /etc/code/limite/$1.sh #$1#" >> /etc/crontab
echo "Usuario: $1 Limite: $2 Aplicado" 
echo "$2" > /etc/code/limite/$1
