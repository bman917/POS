#!/bin/bash
  
MYSQL=`which mysql`

dbname='pos_production'
dbuser='pos_admin'
dbpassword='password' 
  
Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpassword';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
  
$MYSQL -uroot -p -e "$SQL"