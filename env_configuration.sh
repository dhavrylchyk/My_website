#! /bin/bash

# git clone https://github.com/dhavrylchyk/My_website.git
# ########################## sudo cp ~/My_website/contentsettings.py ~/my_blog_app/blog/blog/settings.py
# sudo apt update
# sudo apt install -y python3-pip mysql-server python3.10-venv libmysqlclient-dev default-libmysqlclient-dev
# pip3 install virtualenv django wheel mysqlclient
# sudo systemctl start mysql.service

##### sudo mysqldump -u root -p --opt blog_data > blog_data.sql ### - to do buckup ON FIRST SERVER 

#sudo mysql -u root -e "CREATE DATABASE blog_data"; ### Remoute command to create DB
#sudo mysql -u root -p blog_data <  ./blog_data.sql

#sudo mysql
#sudo mysql -u root -p

# SHOW DATABASES;
# CREATE DATABASE blog_data;
# SHOW DATABASES;
# CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345';
# GRANT ALL ON blog_data.* TO 'djangouser'@'localhost';
# FLUSH PRIVILEGES;


sudo cp ~/My_website/my.cnf   /etc/mysql/my.cnf                                     # mv -i ./my.cnf /etc/mysql/my.cnf
sudo systemctl daemon-reload
sudo systemctl restart mysql
#mkdir my_blog_app
cd ~/My_website/my_blog_app
sudo apt update
sudo apt -y upgrade
python3 -m venv env
. env/bin/activate
django-admin startproject blog
#sudo cp                                       ###  46  nano ~/my_blog_app/blog/blog/settings.py
python3 manage.py makemigrations
cd blog/
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py createsuperuser
sudo ufw allow 8000
sudo ufw status
cd ~/My_website/my_blog_app/blog/
python3 manage.py runserver localhost:8000


[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/My_website
ExecStart=/usr/local/bin/gunicorn \
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          blog.wsgi:application

[Install]
WantedBy=multi-user.target