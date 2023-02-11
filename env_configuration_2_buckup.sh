#! /bin/bash

git clone https://github.com/dhavrylchyk/My_website.git
sudo cp /home/ubuntu/My_website/needrestart.conf /etc/needrestart/needrestart.conf
sudo apt update
sudo apt install -y mysql-server
sudo systemctl start mysql.service
# #                  ##### sudo mysqldump -u root -p --opt blog_data > blog_data.sql ### - to do buckup ON FIRST SERVER 
sudo mysql -u root -e "CREATE DATABASE blog_data"; ### Remoute command to create DB
sudo mysql -u root blog_data < /home/ubuntu/My_website/blog_data.sql


# IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# mysql> CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345';
# Query OK, 0 rows affected (0.02 sec)

# mysql> GRANT ALL ON blog_data.* TO 'djangouser'@'localhost';
# Query OK, 0 rows affected (0.01 sec)

# mysql> FLUSH PRIVILEGES;
# Query OK, 0 rows affected (0.01 sec)

# mysql> exit

sudo mysql -u root -e "CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345'";
sudo mysql -u root -e "GRANT ALL ON blog_data.* TO 'djangouser'@'localhost'";
sudo mysql -u root -e "FLUSH PRIVILEGES";



# #                  # sudo mysql
# #                  # mysql -u root -p
# #                  # sudo mysql -u root -p
# #                  # paswd
# #                  # passwd
# #                  # sudo passwd
# #                  # sudo mysql -u root -p
# #                  # sud0 su
# #                  # sudo su
# #                  # sudo mysql -u root -p
# #                  # sudo mysql
# #                  # cd ..
# #                  # ls -la
# #                  # sudo mysql
sudo cp /home/ubuntu/My_website/my.cnf   /etc/mysql/my.cnf                         #####sudo nano /etc/mysql/my.cnf
sudo systemctl -a daemon-reload                 #sudo systemctl daemon-reload
sudo systemctl restart mysql
# #                  # mkdir my_blog_app
cd /home/ubuntu/My_website/my_blog_app
#python3 -m venv env
# #                  # python3 -v
# #                  # python3 --version
# #                  # pip --version
# #                  # pip3 --version
# #                  # pip
sudo apt update 
sudo apt -y upgrade
# #                  # python3 -V
sudo apt install -y python3-pip
# #                  # pip3 install virtualenv
# #                  # python3 -m venv env
# #                  # apt install python3.10-venv
sudo apt install -y python3.10-venv
python3 -m venv env
. env/bin/activate
pip3 install django
#django-admin startproject blog
cd /home/ubuntu/My_website/my_blog_app/blog 
sudo apt install -y libmysqlclient-dev default-libmysqlclient-dev
pip3 install wheel
sudo pip3 install mysqlclient gunicorn #psycopg2  # gunicorn psycopg2 !!!!!!!!!!!!!!!!!!!!!!!!!!!  psycopg2!!!!!!!!!!!!!!!!!!!!!
# #                  # nano ~/my_blog_app/blog/blog/settings.py
python3 manage.py makemigrations
#cd blog/
# #                  # ls
#python3 manage.py makemigrations
python3 manage.py migrate
# python3 /home/ubuntu/My_website/django_create_user.py

#deactivate #!!!!!!!!!!!!!!!!!!!!!!!!!!!

# python3 manage.py createsuperuser   ################################################### neeed automate!!!!!
#python3 manage.py createsuperuser --username=root --email=root@example.com
echo "from django.contrib.auth.models import User; User.objects.create_superuser('root', 'root@example.com', 'root')" | python manage.py shell
sudo ufw allow 8000
                     # sudo ufw status
cd /home/ubuntu/My_website/my_blog_app/blog/   #cd ~/my_blog_app/blog/
                 # ifconfig
                 # ip config
                 # ip
                 # python3 manage.py runserver 3.70.226.110:8000
# python3 manage.py runserver localhost:8000


deactivate
sudo cp /home/ubuntu/My_website/services/gunicorn.socket /etc/systemd/system/gunicorn.socket
sudo cp /home/ubuntu/My_website/services/gunicorn.service /etc/systemd/system/gunicorn.service
# chown -R www-data:root ~/django_project
sudo chown -R www-data:root ~/
sudo systemctl daemon-reload
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
sudo cp /home/ubuntu/My_website/nginx/django.conf /etc/nginx/conf.d/django.conf
sudo systemctl restart nginx


# IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# mysql> CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345';
# Query OK, 0 rows affected (0.02 sec)

# mysql> GRANT ALL ON blog_data.* TO 'djangouser'@'localhost';
# Query OK, 0 rows affected (0.01 sec)

# mysql> FLUSH PRIVILEGES;
# Query OK, 0 rows affected (0.01 sec)

# mysql> exit


# gunicorn --bind 0.0.0.0:8000 blog.wsgi