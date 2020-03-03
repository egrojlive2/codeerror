#!/bin/bash
apt install net-tools -y > /dev/null 2>&1
########################################################################
# Color esthetics
########################################################################
CNC='\e[0m' # No color
C0='\033[1;37m' # White
C1='\033[0;35m' # Purple
C2='\033[0;32m' # Green # Not Used
C3='\033[0;37m' # Light Gray
C4='\033[1;32m' # Light Green
C5='\033[0;31m' # Red
C6='\033[1;33m' # Yellow
C7='\033[0;34m' # Blue

########################################################################
# Parameters
########################################################################

# CPU Temperature default is in degrees Celsius
# You can output it in Degrees Farenheit by changing the parameter below
# to true
isCPUTempFarenheit=false

########################################################################
# Commands configuration
########################################################################

# Calculate the proc count. Subtracting 5 so that the count accurately reflects the number
# of procs rather than the number of lines in the output
PROCCOUNT=$(ps -Afl | wc -l)
PROCCOUNT=$((PROCCOUNT - 5))
# Get the groups the current user is a member of
GROUPZ=$(groups)
# Get the current user's name
USER=$(whoami)
# Get all members of the sudo group
ADMINS=$(grep --regex "^sudo" /etc/group | awk -F: '{print $4}' | tr ',' '|')
ADMINSLIST=$(grep -E "$ADMINS" /etc/passwd | tr ':' ' ' | tr ',' ' ' | awk '{print $5,$6,"("$1")"}' | tr '\n' ',' | sed '$s/.$//')

# Check the updates
#UPDATESAVAIL=$(cat /var/zzscriptzz/MOTD/updates-available.dat)

# Check all local interfaces
INTERFACE=$(route | grep '^default' | grep -o '[^ ]*$')

# Check if the system has a thermo sensor
if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
    # Get the tempurature from the probe
    cur_temperature=$(cat /sys/class/thermal/thermal_zone0/temp)
    # Check the farenheit flag
    if [ "$isCPUTempFarenheit" = true ]; then
        # If farenheit then convert to F
        cur_temperature="$(echo "$cur_temperature / 1000" | bc -l | xargs printf "%.2f")"
        cur_temperature="$(echo "$cur_temperature * 1.8 + 32" | bc -l | xargs printf "%1.0f") °F"
    else
        # Else just print the temp in C
        cur_temperature="$(echo "$cur_temperature / 1000" | bc -l | xargs printf "%1.0f")°C"
    fi
else
    # If no sensor then just print N/A
    cur_temperature="N/A"
fi

# Check and format the open ports on the machine
OPEN_PORTS_IPV4=$(netstat -lnt | awk 'NR>2{print $4}' | grep -E '0.0.0.0:' | sed 's/.*://' | sort -n | uniq | awk -vORS=, '{print $1}' | sed 's/,$/\n/')
OPEN_PORTS_IPV6=$(netstat -lnt | awk 'NR>2{print $4}' | grep -E ':::' | sed 's/.*://' | sort -n | uniq | awk -vORS=, '{print $1}' | sed 's/,$/\n/')

# Get the list of processes and sort them by most mem usage and most cpu usage
ps_output="$(ps aux)"
mem_top_processes="$(printf "%s\\n" "${ps_output}" | awk '{print "\033[1;37m"$2, $4"%", "\033[1;32m"$11}' | sort -k2rn | head -3 | awk '{print " \033[0;35m+\t\033[1;32mID: "$1, $3, $2}')"
cpu_top_processes="$(printf "%s\\n" "${ps_output}" | awk '{print "\033[1;37m"$2, $3"%", "\033[1;32m"$11}' | sort -k2rn | head -3 | awk '{print " \033[0;35m+\t\033[1;32mID: "$1, $3, $2}')"

# Get your remote IP address using external resource ipinfo.io
remote_ip="$(wget http://ipinfo.io/ip -qO -)"
# Get your local IP address
local_ip="$(ip addr list "$INTERFACE" | grep "inet " | cut -d' ' -f6| cut -d/ -f1)"
# Get the total machine uptime in specific dynamic format 0 days, 0 hours, 0 minutes
machine_uptime="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')"
# Get your linux distro name
distro_pretty_name="$(grep "PRETTY_NAME" /etc/*release | cut -d "=" -f 2- | sed 's/"//g')"
# Get the brand and model of your CPU
cpu_model_name="$(grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' | head -1)"

# Get memory usage to be displayed
memory_percent="$(free -m | awk '/Mem/ { if($2 ~ /^[1-9]+/) memm=$3/$2*100; else memm=0; printf("%3.1f%%", memm) }')"
memory_free_mb="$(free -t -m | grep "Mem" | awk '{print $4}')"
memory_used_mb="$(free -t -m | grep "Mem" | awk '{print $3}')"
memory_available_mb="$(free -t -m | grep "Mem" | awk '{print $2}')"

# Get SWAP usage to be displayed
swap_percent="$(free -m | awk '/Swap/ { if($2 ~ /^[1-9]+/) swapm=$3/$2*100; else swapm=0; printf("%3.1f%%", swapm) }')"
swap_free_mb="$(free -t -m | grep "Swap" | awk '{print $4}')"
swap_used_mb="$(free -t -m | grep "Swap" | awk '{print $3}')"
swap_available_mb="$(free -t -m | grep "Swap" | awk '{print $2}')"

# Get HDD usage to be displayed
hdd_percent="$(df -H | grep "/$" | awk '{ print $5 }')"
hdd_free="$(df -hT | grep "/$" | awk '{print $5}')"
hdd_used="$(df -hT | grep "/$" | awk '{print $4}')"
hdd_available="$(df -hT | grep "/$" | awk '{print $3}')"

#Get last login information (user, ip)
last_login_user="$(last -a "$USER" | head -2 | awk 'NR==2{print $3,$4,$5,$6}')"
last_login_ip="$(last -a "$USER" | head -2 | awk 'NR==2{print $10}')"

# Get the 3 load averages
read -r loadavg_one loadavg_five loadavg_fifteen rest < /proc/loadavg

# Get the current usergroup and translate it to something human readable
if [[ "$GROUPZ" == *"sudo"* ]]; then
    USERGROUP="Administrator"
elif [[ "$USER" == "root" ]]; then
    USERGROUP="Root"
elif [[ "$USER" == "$USER" ]]; then
    USERGROUP="Regular User"
else
    USERGROUP="$GROUPZ"
fi

# Clear the screen and reset the scrollback
#clear && printf '\e[3J'

# Print a city scape (purely aesthetic)
# If "you no like", delete it or replace with your own ;)
# Print out all of the information collected using the script
# ($local_ip)
<span style="color: #ffffff;">prueba spna</span>
echo -e "<font color=\"#FFBF38\">=========:System Data:=========</font><br>
<font color=\"#77C500\">Hostname =</font>  $(hostname) ($(hostname --fqdn))<br>
<font color=\"#77C500\">IPv4 Address =</font>  $remote_ip<br>
<font color=\"#77C500\">Uptime =</font>  $machine_uptime<br>
<font color=\"#77C500\">Time =</font>  $(date)<br>
<font color=\"#77C500\">CPU Temp =</font>  $cur_temperature<br>
<font color=\"#77C500\">Processes =</font>  $PROCCOUNT of $(ulimit -u) max<br>
<font color=\"#77C500\">Load Averages =</font>  ${loadavg_one}, ${loadavg_five}, ${loadavg_fifteen} (1, 5, 15 min)<br>
<font color=\"#77C500\">Distro =</font>  $distro_pretty_name ($(uname -r))<br>
<font color=\"#77C500\">CPU =</font>  $cpu_model_name<br>
<font color=\"#77C500\">Memory =</font>  $memory_percent (${memory_free_mb}MB Free, ${memory_used_mb}MB/${memory_available_mb}MB Used)<br>
<font color=\"#77C500\">Swap   =</font>  $swap_percent (${swap_free_mb}MB Free, ${swap_used_mb}MB/${swap_available_mb}MB Used)<br>
<font color=\"#77C500\">HDD Usage =</font>  $hdd_percent (${hdd_free}B Free, ${hdd_used}B/${hdd_available}B Used)<br><br>
<font color=\"#FFBF38\">=========: User Data :=========</font><br>
<font color=\"#77C500\">Username =</font>  $USER ($USERGROUP)<br>
<font color=\"#77C500\">Last Login =</font>  $last_login_user from $last_login_ip<br>
<font color=\"#77C500\">Sessions =</font>  $(who | grep -c "$USER")<br><br>

<font color=\"#FFBF38\">=========: Helpful Information :=========</font><br>
<font color=\"#77C500\">OpenPorts IPv4 =</font>  $OPEN_PORTS_IPV4<br>
<font color=\"#77C500\">OpenPorts IPv6 =</font>  $OPEN_PORTS_IPV6<br><br>"

opensshport="$(netstat -ntlp | grep -i ssh | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
dropbearport="$(netstat -nlpt | grep -i dropbear | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
stunnel4port="$(netstat -nlpt | grep -i stunnel | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
openvpnport="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
if [ -f /etc/squid3/squid.conf ];
then
squidport="$(cat /etc/squid3/squid.conf | grep -i http_port | awk '{print $2}')"
else
squidport="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}')"
fi
if [ -f /etc/default/sslh ];
then
puertouniversal="$(cat /etc/default/sslh | grep -i listen | awk '{print $4}')"
else
puertouniversal="no configurado"
fi
echo -e "<br><font color=\"#FFBF38\">=========: PUERTOS ACTIVOS :=========</font><br>"
echo -e "<br><font color=\"#77C500\">         Port 443        :  </font>"$puertouniversal
echo -e "<br><font color=\"#77C500\">         Port OpenSSH    :  </font>"$opensshport
echo -e "<br><font color=\"#77C500\">         Port Dropbear   :  </font>"$dropbearport
echo -e "<br><font color=\"#77C500\">         Port SSL        :  </font>"$stunnel4port
echo -e "<br><font color=\"#77C500\">         Port Squid      :  </font>"$squidport
echo -e "<br><font color=\"#77C500\">         Port OpenVPN    :  </font>"$openvpnport
