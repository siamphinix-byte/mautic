FROM mautic/mautic:5-apache

# Copy your custom fork files directly over the default installation directory
COPY . /var/www/html

# Reset permissions so the webserver can execute your files
USER root
RUN chown -R www-data:www-data /var/www/html

USER www-data
