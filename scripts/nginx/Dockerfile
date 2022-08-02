FROM			debian:bullseye
LABEL			maintainer="rbourgea <rbourgea@student.42.fr>"

EXPOSE			443
EXPOSE			80

RUN				apt-get update && apt-get -y upgrade
RUN				apt-get install -y openssl
RUN				apt-get install -y nginx

RUN				openssl req -x509 -nodes -days 365 -newkey rsa:2048  -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt -subj "/C=FR/ST=Ile de France/L=Paris/O=42/OU=cloud-1/CN=*.fttranscendence.site"

COPY			./default /etc/nginx/sites-available/default
COPY			./phpmyadmin /etc/nginx/sites-available/phpmyadmin
RUN				ln -s /etc/nginx/sites-available/phpmyadmin /etc/nginx/sites-enabled/phpmyadmin

ENTRYPOINT		["nginx", "-g", "daemon off;"]
