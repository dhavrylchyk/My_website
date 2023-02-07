#! /bin/bash

git clone https://github.com/dhavrylchyk/My_website.git
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql.service
# #                  ##### sudo mysqldump -u root -p --opt blog_data > blog_data.sql ### - to do buckup ON FIRST SERVER 
sudo mysql -u root -e "CREATE DATABASE blog_data"; ### Remoute command to create DB
sudo mysql -u root -p blog_data <  ./blog_data.sql


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
sudo cp ~/My_website/my.cnf   /etc/mysql/my.cnf                         #####sudo nano /etc/mysql/my.cnf
sudo systemctl daemon-reload
sudo systemctl restart mysql
# #                  # mkdir my_blog_app
cd ~/My_website/my_blog_app
python3 -m venv env
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
sudo apt install python3.10-venv
python3 -m venv env
. env/bin/activate
pip3 install django
django-admin startproject blog
sudo apt install -y libmysqlclient-dev default-libmysqlclient-dev
pip3 install wheel
pip3 install mysqlclient
# #                  # nano ~/my_blog_app/blog/blog/settings.py
python3 manage.py makemigrations
cd blog/
# #                  # ls
python3 manage.py makemigrations
python3 manage.py migrate
# python3 manage.py createsuperuser   ################################################### neeed automate!!!!!
# sudo ufw allow 8000
                     # sudo ufw status
# cd ~/My_website/my_blog_app/blog/   #cd ~/my_blog_app/blog/
                 # ifconfig
                 # ip config
                 # ip
                 # python3 manage.py runserver 3.70.226.110:8000
# python3 manage.py runserver localhost:8000



# IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# mysql> CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345';
# Query OK, 0 rows affected (0.02 sec)

# mysql> GRANT ALL ON blog_data.* TO 'djangouser'@'localhost';
# Query OK, 0 rows affected (0.01 sec)

# mysql> FLUSH PRIVILEGES;
# Query OK, 0 rows affected (0.01 sec)

# mysql> exit
