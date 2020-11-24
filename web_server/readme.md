一、nginx

二、apache

三、php
	systemctl start php-fpm

四、mysql
1、Init
```
# mysql_install_db --datadir=/var/lib/mysql
# chown mysql -R /var/lib/mysql
# systemctl start mysql
# mysqladmin -u root -p password
//login root and delete users without username
```

