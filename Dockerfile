FROM	debian:buster

LABEL	maintainer="seuyu@student.42seoul.kr"

COPY	srcs/. /root/

RUN	apt-get -y update && apt-get -y upgrade

RUN	apt-get install -y nginx \
	mariadb-server \
	php-mysql \
	php-mbstring \
	openssl \
	vim \
	wget \
	php7.3-fpm

RUN	openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Gam/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt

RUN	mv localhost.dev.crt etc/ssl/certs/ && \
	mv localhost.dev.key etc/ssl/private/ && \
	chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

RUN	mv /root/default /etc/nginx/sites-available

RUN	wget https://wordpress.org/latest.tar.gz && \
	tar -xvf latest.tar.gz && \
	rm latest.tar.gz && \
	mv wordpress/ var/www/html/ && \
	chown -R www-data:www-data /var/www/html/wordpress && \
	mv /root/wp-config.php var/www/html/wordpress

RUN	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
	tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz && \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz && \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin && \
	mv phpmyadmin /var/www/html/ && \
	mv /root/config.inc.php var/www/html/phpmyadmin

RUN	service mysql start && \
	echo "CREATE DATABASE wordpress;" | mysql -u root && \
	echo "CREATE USER 'seuyu'@'localhost';" | mysql -u root && \
	echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'seuyu'@'localhost' IDENTIFIED BY 'db1234';" | mysql -u root && \
	echo "FLUSH PRIVILEGES;" | mysql -u root

EXPOSE	80 443

CMD	bash /root/run.sh
