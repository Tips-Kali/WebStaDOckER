#!/bin/sh

show "DEPLOIEMENT DU PROJET"

# ...vos actions perso

# Glances
if [ $installedGlance == "oui" ]; then
    glances;
fi