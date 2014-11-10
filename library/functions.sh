#!/bin/sh

function wait(){
    echo '...';
    sleep 1;
    echo '...';
    sleep 1;
    echo '...';
    sleep 1;
}

function show(){
    echo ''
    echo ''
    echo ''

    NUMBER=$(( $RANDOM % 5 ))

    COLOURS=(
    "\e[93m"
    "\e[96m"
    "\e[92m"
    "\e[91m"
    "\e[95m"
    )

    echo -e ${COLOURS[$NUMBER]}

    echo '######################################################'
    echo '#####' $1
    echo '######################################################'
    wait;
}

function subShow(){
    echo ''
    echo ''

    NUMBER=$(( $RANDOM % 5 ))

    COLOURS=(
    "\e[93m"
    "\e[96m"
    "\e[92m"
    "\e[91m"
    "\e[95m"
    )

    echo -e ${COLOURS[$NUMBER]}

    echo '   ------------------------------------------------------'
    echo '   -----' $1
    echo '   ------------------------------------------------------'
    wait;
}

function version_compare {

IFS='.' read -ra ver1 <<< "$1"
IFS='.' read -ra ver2 <<< "$2"

[[ ${#ver1[@]} -gt ${#ver2[@]} ]] && till=${#ver1[@]} || till=${#ver2[@]}

for ((i=0; i<${till}; i++)); do

    local num1; local num2;

    [[ -z ${ver1[i]} ]] && num1=0 || num1=${ver1[i]}
    [[ -z ${ver2[i]} ]] && num2=0 || num2=${ver2[i]}

    if [[ $num1 -gt $num2 ]]; then
        echo ">"; return 0
    elif
       [[ $num1 -lt $num2 ]]; then
        echo "<"; return 0
    fi
done

echo "="; return 0
}

