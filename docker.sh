#!/bin/sh
echo "-------------------------"
echo "install graphite carbon"
echo "-------------------------"
echo graphite-carbon graphite-carbon/postrm_remove_databases boolean true | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt install -y -q graphite-carbon
echo "-------------------------"
echo "install graphite web"
echo "-------------------------"
DEBIAN_FRONTEND=noninteractive apt install -y -q graphite-web
echo "-------------------------"
echo "enable carbon cache"
echo "-------------------------"
# when it is not container you can use systemctl enable and start commands
sed -i s/CARBON_CACHE_ENABLED=false/CARBON_CACHE_ENABLED=true/g /etc/default/graphite-carbon
service carbon-cache start
echo "-------------------------"
echo "graphite django settings - non-prod"
echo "-------------------------"
sed -i "s/#SECRET_KEY = 'UNSAFE_DEFAULT'/SECRET_KEY = 'YOUR_OWN_SUPER_SECRET_KEY'/g" /etc/graphite/local_settings.py
sed -i "s/#DEBUG = True/DEBUG = True/g" /etc/graphite/local_settings.py
sed -i "s/#ALLOWED_HOSTS/ALLOWED_HOSTS/g" /etc/graphite/local_settings.py
echo "-------------------------"
echo "database migration"
echo "-------------------------"
echo "fix migration errors"
sed -i 's/from cgi import parse_qs/from urllib.parse import parse_qs/' /usr/lib/python3/dist-packages/graphite/render/views.py
sed -i -E "s/('django.contrib.contenttypes')/\1,\n 'django.contrib.messages'/" /usr/lib/python3/dist-packages/graphite/app_settings.py
echo "do db migration"
/usr/lib/python3/dist-packages/django/bin/django-admin.py migrate --settings=graphite.settings
chown _graphite:_graphite /var/lib/graphite/graphite.db
echo "-------------------------"
echo "webserver settings"
echo "-------------------------"
apt install apache2 libapache2-mod-wsgi-py3 -y
cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
a2dissite 000-default
a2ensite apache2-graphite
chown _graphite:_graphite /var/log/graphite/info.log
chown _graphite:_graphite /var/log/graphite/exception.log
service apache2 restart
echo "-------------------------"
echo "fix static files"
echo "-------------------------"
ln -s /usr/lib/python3/dist-packages/django/contrib/admin/static/admin/ /usr/share/graphite-web/static/admin
echo "-------------------------"
echo "Create superuser for djangoadmin"
echo "-------------------------"
echo "go into docker image with the command below from terminal:"
echo "docker exec -it graphite /bin/bash"
echo " "
echo "create your user in the container with this command:"
echo "/usr/lib/python3/dist-packages/django/bin/django-admin.py createsuperuser --settings=graphite.settings"