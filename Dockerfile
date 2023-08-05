FROM ubuntu:latest
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update -y \
    && apt install supervisor wget vim tzdata -y \
    && apt install unzip php apache2 php-mysqlnd -y \
    && mkdir -p /etc/encryption \
    && wget https://wordpress.org/latest.zip \
    && rm -rf /var/www/html/* \
        && rm -rf /etc/apache2/sites-available/default-ssl.conf \
        &&rm -rf /etc/apache2/sites-available/000-default.conf \
        && unzip latest.zip -d /var/www/html/ \
    && mv /var/www/html/wordpress/* /var/www/html/ \
    && mv /var/www/html/wp-config-sample.php  /var/www/html/wp-config.php \
    && sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php \
    && sed -i 's/username_here/admin/g' /var/www/html/wp-config.php \
    && sed -i 's/password_here/Qwert123/g' /var/www/html/wp-config.php \
    && sed -i 's/localhost/database-1.cp35ofbjjbaa.us-east-1.rds.amazonaws.com/g' /var/www/html/wp-config.php
COPY encryption /etc/encryption
COPY ssl-params.conf /etc/apache2/conf-available/
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
EXPOSE 3306
EXPOSE 80
CMD ["/usr/bin/supervisord"]
