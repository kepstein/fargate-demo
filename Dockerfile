FROM httpd
COPY build/index.html /usr/local/apache2/htdocs/index.html
COPY build/woohoo.jpg /usr/local/apache2/htdocs/woohoo.jpg
