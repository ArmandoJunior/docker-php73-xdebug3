FROM php:7.3.6-fpm-alpine3.9

WORKDIR /var/www
RUN rm -rf /var/www/html
COPY . /var/www
RUN ln -s public html

RUN apk add --no-cache shadow openssl vim bash mysql-client nodejs npm git $PHPIZE_DEPS
RUN docker-php-ext-install pdo pdo_mysql

RUN touch /home/www-data/.bashrc | echo "PS1='\w\$ '" >> /home/www-data/.bashrc
RUN pecl install -f xdebug \
&& echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
&& docker-php-ext-enable xdebug


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN usermod -u 1000 www-data

EXPOSE 9000
ENTRYPOINT ["php-fpm"]