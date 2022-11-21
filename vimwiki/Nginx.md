# Nginx

## Commands

```sh
nginx # start
nginx -s stop # fast shutdown
nginx -s quit # graceful shutdown
nginx -s reload # reload config
nginx -V # display paths and configuration
```

## Locations

Config directory is `/usr/local/etc/nginx/`
Config file is `nginx.conf`
Document root is `/usr/local/var/www/`
PHP FPM conf is `/usr/local/etc/php/7.4/php-fpm.conf`
PHP FPM executable is located at `/usr/local/Cellar/php/7.4.9/sbin/php-fpm`
dnsmasq conf file is `/usr/local/etc/dnsmasq.conf`

## Setup

Install nginx with:

```sh
brew upgrade
brew install nginx
```

Add symlink from your site to document root

```sh
ln -sf ~/Dev/projects/wmkt/company-site-container/ /usr/local/var/www
```

Make symbolic link for php-fpm.conf file

```sh
sudo ln -sf /usr/local/etc/php/7.4/php-fpm.conf /private/etc/php-fpm.conf
```

Check that the configuration is valid by running:

```sh
php-fpm --test
```

You may need to alter the configuration somewhat to get it to work.
