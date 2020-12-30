#!/bin/bash

service mysql start


mysql < var/www/html/phpmyadmin/sql/create_tables.sql

service php7.3-fpm start
service nginx restart

bash
