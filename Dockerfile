FROM ubuntu:trusty
MAINTAINER Piotr Biernat <keedosn@gmail.com> 

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
  apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt

# Add image configuration and scripts
ADD start-nginx.sh /start-nginx.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD create-mysql-user.sh /create-mysql-user.sh
ADD start.sh /start.sh

RUN chmod 755 /*.sh

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Configure /app folder with sample app
RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

# Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

EXPOSE 80

CMD ["/run.sh"]
