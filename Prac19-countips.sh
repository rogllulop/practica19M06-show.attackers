#!/bin/bash
# Escribe todas las ip del fichero syslog-sample en 'total-ips.txt'
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $1 > total-ips.txt
# Ordena las IP unicas del fichero
function pause(){
   read -p "$*"
}

countwcips=0;
countwcsyslog=0;
file=$1;
wcips=$(sort -u total-ips.txt | wc -l)

wcsyslog=$(cat syslog-sample | wc -l)

echo "Count,IP,Location"

while [ $countwcips -lt $wcips ]; do

       	total=($(sort -u total-ips.txt))
	ip=${total[$countwcips]}
	countipsfailed=$(grep -o -c "Failed password for root from $ip" $file)
	countips=$(grep -o -c "$ip" syslog-sample)
	val=$(geoiplookup $ip)
	var=$(echo "$val" | cut -b 28-40 )
	echo "--------------------------------"
	echo "PUBLIC IP: $ip"
	echo "--------------------------------"
	echo " Times in file: $countips"
	echo " Times FAILED password root: $countipsfailed"
	echo " LOCATION: $var"
	if [ $countipsfailed -ge 10 ]; then
	echo "$countipsfailed,$ip,$var" >> show-all-ips
	fi
	countwcips=$[$countwcips+1];

done
	pause "Press Enter"
	clear
	echo "Count,Ip,Location"
	echo "-----------------"
	sort -nr show-all-ips
	rm show-all-ips
