一、nginx

二、apache
1、replace conf files,
2、add james/git to /etc/group --> http:::james,git
3、enable https
```
mkdir -p /etc/httpd/secure/
cd /etc/httpd/secure/
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 3650 -out ca.crt
openssl req -newkey rsa:4096 -nodes -sha256 -keyout server.key -out server.csr
openssl x509 -req -days 1000 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```

三、php
	systemctl start php-fpm

四、mysql
1、Init
a) mysql 10+
```
# mysql_install_db --datadir=/var/lib/mysql
# chown mysql -R /var/lib/mysql
# systemctl start mysql
# mysqladmin -u root -p password
//login root and delete users without username
b) mariadb
# rm -rf /var/lib/mysql
# mkdir /var/lib/mysql -p
# chown mysql -R /var/lib/mysql
# mysql -uroot
MariaDB [(none)]> use mysql;
MariaDB [mysql]> UPDATE mysql.user SET password = PASSWORD('newpassward') WHERE user = 'root';
MariaDB [mysql]> FLUSH PRIVILEGES;
```

五、gitweb
1、build from source code
```
$ git clone git://git.kernel.org/pub/scm/git/git.git
$ cd git/
$ make GITWEB_PROJECTROOT="/srv/git" prefix=/usr gitweb
$ sudo cp -Rf gitweb /var/www/
```

2、install dependency
```
pacman -S \
perl-cgi \
perl-cgi-fast \
perl-cgi-session \
```

六、gitolite
```
	######## Warning ########
	# make sure $HOME permission is 755 or less,
	# group write permission will not allow ssh authorized_keys works
```








