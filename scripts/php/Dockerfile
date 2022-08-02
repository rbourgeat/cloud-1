FROM	debian:bullseye
LABEL	maintainer="rbourgea <rbourgea@student.42.fr>"

EXPOSE	9000

RUN		apt-get update
RUN		apt-get -y upgrade
RUN		apt-get install -y curl wget

RUN		apt-get install -y php7.4-fpm
RUN		apt-get install -y php7.4-mysql
RUN		apt-get install -y php7.4-cgi
RUN		apt-get install -y php7.4-bz2 php7.4-zip php7.4-mbstring php7.4-gd php7.4-curl php-imagick

RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN		chmod +x wp-cli.phar
RUN		mv wp-cli.phar /usr/local/bin/wp

COPY	./www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY	./php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
COPY	./script.sh /usr/local/bin/script.sh
RUN		chmod +x /usr/local/bin/script.sh

ENTRYPOINT [ "script.sh" ]
