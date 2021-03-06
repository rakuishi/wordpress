FROM tutum/lamp:latest
MAINTAINER Fernando Mayo <fernando@tutum.co>, Feng Honglin <hfeng@tutum.co>

# Install plugins
RUN apt-get update && \
  apt-get -y install php5-gd && \
  rm -rf /var/lib/apt/lists/*

# Download latest version of Wordpress into /app
RUN rm -fr /app && git clone --depth=1 https://github.com/WordPress/WordPress.git /app

# Configure Wordpress to connect to local DB
ADD wp-config.php /app/wp-config.php
ADD .htaccess /app/.htaccess
# ADD public_html/wp-content /app/wp-content

# Modify permissions to allow plugin upload
RUN chown -R www-data:www-data /app/wp-content /var/www/html

# Add database setup script
# See https://github.com/tutumcloud/lamp/blob/master/create_mysql_admin_user.sh
ADD mysql-setup.sh /mysql-setup.sh
RUN chmod +x /*.sh

EXPOSE 80 3306
CMD ["/run.sh"]
