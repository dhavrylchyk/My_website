#! /bin/bash

#git clone https://github.com/dhavrylchyk/My_website.git
sudo apt update
sudo apt install -y python3-pip mysql-server python3.10-venv libmysqlclient-dev default-libmysqlclient-dev
pip3 install virtualenv django wheel mysqlclient
sudo systemctl start mysql.service
#sudo mysql
#sudo mysql -u root -p
mv -i ./my.cnf /etc/mysql/my.cnf
sudo systemctl daemon-reload
sudo systemctl restart mysql
mkdir my_blog_app
cd my_blog_app
sudo apt update
sudo apt -y upgrade
python3 -m venv env
. env/bin/activate
django-admin startproject blog
                                        46  nano ~/my_blog_app/blog/blog/settings.py
python3 manage.py makemigrations
cd blog/
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py createsuperuser
sudo ufw allow 8000
sudo ufw status
cd ~/my_blog_app/blog/
python3 manage.py runserver localhost:8000
