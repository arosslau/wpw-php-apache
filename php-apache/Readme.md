This directory is to build an own werpflegtwie docker "php-apache" image. This image is referenced in dockert-compose.yml

```
sudo docker build -t werpflegtwie/php-apache .
```

If you want to rebuild it, destroy it first:

```
sudo docker rmi -f werpflegtwie/php-apache
```