#!/bin/bash

trap ctrl_c INT

function ctrl_c() {
    echo -e "\n\e[5;31mScript interrupted. Exiting...\e[0m"
    exit 1
}

function show_usage() {
    echo -e "\e[5;34m ========== HOSTS FINDER ========== \e[0m"
    echo -e "------------  Use mode ----------"
    echo -e "*** --> ./hostsFinder.sh <network> <port> <initial host> <final host> <-- ***"
    echo -e "Example: ./hostFinder.sh 192.168.1 80 1 255"
    echo -e "------------ Use mode -----------"
    echo -e "\e[5;34m ========== HOSTS FINDER ========== \e[0m"
}

if [ -z "$1" ] || [ -z "$2" ]; then
    echo -e "\e[5;31m =-=-= ERROR =-=-= \e[0m"
    echo -e "-> Script error: Network or port parameter not found!"
    show_usage
    exit 1
fi

initial_host=${3:-1}
final_host=${4:-254}

if ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo -e "\e[5;31m =-=-= ERROR =-=-= \e[0m"
    echo -e "-> Invalid port number: $2"
    exit 1
fi

echo -e "\e[5;34m ========== HOSTS FINDER ========== \e[0m"
echo -e "Scanning network: $1"
echo -e "Port: $2"
echo -e "Host range: $initial_host - $final_host"
echo -e "------------------------------------"

for ip in $(seq "$initial_host" "$final_host"); do
    response=$(hping3 -c 1 -S -p "$2" "$1.$ip" 2> /dev/null | grep "flags=")

    if [ $? -eq 0 ]; then
        echo -e "\e[32mHost $1.$ip is UP (Port $2 open)\e[0m"
    else
        echo -e "\e[31mHost $1.$ip is DOWN (Port $2 closed or host unreachable)\e[0m"
    fi
done

echo -e "\e[5;34m ========== HOSTS FINDER COMPLETE ========== \e[0m"