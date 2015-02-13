FROM debian
MAINTAINER jipe bar <jipebar@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
#RUN apt-get upgrade -yq

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN apt-get install -yq apache2
RUN apt-get install -yq libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl
# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid 

RUN a2enmod php5
RUN a2enmod rewrite

EXPOSE 80
 
# Copy site into place.
ADD www /var/www/site
 
# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-available/

RUN a2dissite default
RUN a2ensite apache-config.conf
 
# By default, simply start apache
CMD /usr/sbin/apache2ctl -D FOREGROUND
