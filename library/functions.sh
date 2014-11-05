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