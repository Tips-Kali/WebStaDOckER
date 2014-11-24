#!/bin/bash

# Run PHP
service php5-fpm start;

# Run NGINX
service nginx start;
lsof -i tcp:80;

# Run DataBase
service mysql start;