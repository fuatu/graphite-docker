# Installation
run the command below in terminal
```
$ docker-compose up
```

# create superuser
open another terminal to create superuser
go into docker image with the command below from terminal:"
```
$ docker exec -it graphite /bin/bash"
```
create your user in the container with this command:"
```
$ /usr/lib/python3/dist-packages/django/bin/django-admin.py createsuperuser --settings=graphite.settings
```

# Accessing from browser
graphite
http://localhost:8000

django admin
http://localhost:8000/admin/