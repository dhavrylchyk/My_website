#! /bin/bash

git clone https://github.com/dhavrylchyk/My_website.git
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf
echo "COMMAND 1 git clone https://github.com/dhavrylchyk/My_website.git"
sudo cp /home/ubuntu/My_website/needrestart.conf /etc/needrestart/needrestart.conf
echo "COMMAND 2 sudo cp /home/ubuntu/My_website/needrestart.conf /etc/needrestart/needrestart.conf"
sudo apt update
echo "COMMAND 3 sudo apt update"
sudo apt install -y mysql-server 
echo "COMMAND 4 sudo apt install -y mysql-server"
sudo apt-get install python3-pip python3-dev libpq-dev curl nginx -y
echo "COMMAND 4 C sudo apt-get install python3-pip python3-dev libpq-dev curl nginx -y"
# sudo systemctl start nginx
echo "COMMAND 4 C sudo systemctl start nginx"
# sudo systemctl enable nginx
echo "COMMAND 4 C sudo systemctl enable nginx"
sudo systemctl start mysql.service
echo "COMMAND 5 sudo systemctl start mysql.service"
# #                  ##### sudo mysqldump -u root -p --opt blog_data > blog_data.sql ### - to do buckup ON FIRST SERVER 
sudo mysql -u root -e "CREATE DATABASE blog_data"; ### Remoute command to create DB
echo "COMMAND 6 sudo mysql -u root -e CREATE DATABASE blog_data;"
sudo mysql -u root blog_data < /home/ubuntu/My_website/blog_data.sql
echo "COMMAND 7 sudo mysql -u root blog_data < /home/ubuntu/My_website/blog_data.sql"

sudo mysql -u root -e "CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345'";
echo "COMMAND 8 sudo mysql -u root -e CREATE USER 'djangouser'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Panzer12345';"
sudo mysql -u root -e "GRANT ALL ON blog_data.* TO 'djangouser'@'localhost'";
echo "COMMAND 9 sudo mysql -u root -e GRANT ALL ON blog_data.* TO 'djangouser'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES";
echo "COMMAND 10 sudo mysql -u root -e FLUSH PRIVILEGES;"
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
echo "COMMAND 11 sudo cp /home/ubuntu/My_website/my.cnf   /etc/mysql/my.cnf"
sudo systemctl -a daemon-reload                 #sudo systemctl daemon-reload
echo "COMMAND 12 sudo systemctl -a daemon-reload"
sudo systemctl restart mysql
# #                  # mkdir my_blog_app
cd /home/ubuntu/My_website/my_blog_app
echo "COMMAND 13 cd /home/ubuntu/My_website/my_blog_app"
#python3 -m venv env
# #                  # python3 -v
# #                  # python3 --version
# #                  # pip --version
# #                  # pip3 --version
# #                  # pip
sudo apt update
echo "COMMAND 14 sudo apt update"
sudo apt -y upgrade
echo "COMMAND 15 sudo apt -y upgrade"
# #                  # python3 -V
sudo apt install -y python3-pip
echo "COMMAND 16 sudo apt install -y python3-pip"
# #                  # pip3 install virtualenv
# #                  # python3 -m venv env
# #                  # apt install python3.10-venv
sudo apt install -y python3.10-venv
echo "COMMAND 17 sudo apt install -y python3.10-venv"
python3 -m venv env
echo "COMMAND 18 python3 -m venv env"
. env/bin/activate
sudo apt install -y mysql-server        ###### ALREADY INSTALLED ABBOVE
echo "COMMAND 19 . env/bin/activate"
pip3 install django gunicorn psycopg2-binary        ####### try without sudo
echo "COMMAND 20 pip3 install django"
#django-admin startproject blog
cd /home/ubuntu/My_website/my_blog_app/blog 
echo "COMMAND 21 cd /home/ubuntu/My_website/my_blog_app/blog "
sudo apt install -y libmysqlclient-dev default-libmysqlclient-dev
echo "COMMAND 22 sudo apt install -y libmysqlclient-dev default-libmysqlclient-dev"
pip3 install wheel
echo "COMMAND 23 pip3 install wheel"
pip3 install mysqlclient   ############ sudo pip3 install mysqlclient
echo "COMMAND 24 pip3 install mysqlclient"
# #                  # nano ~/my_blog_app/blog/blog/settings.py
python3 manage.py makemigrations
echo "COMMAND 25 python3 manage.py makemigrations"
#cd blog/
# #                  # ls
#python3 manage.py makemigrations
python3 manage.py migrate
echo "COMMAND 26 python3 manage.py migrate"
# python3 /home/ubuntu/My_website/django_create_user.py

# python3 manage.py createsuperuser   ################################################### neeed automate!!!!!
#python3 manage.py createsuperuser --username=root --email=root@example.com
echo "from django.contrib.auth.models import User; User.objects.create_superuser('root', 'root@example.com', 'root')" | python3 manage.py shell
echo "COMMAND 27 echo from django.contrib.auth.models import User; User.objects.create_superuser('root', 'root@example.com', 'root') | python manage.py shell"
sudo ufw allow 8000
echo "COMMAND 28 sudo ufw allow 8000"
                     # sudo ufw status
#cd /home/ubuntu/My_website/my_blog_app/blog/   #cd ~/my_blog_app/blog/
echo "COMMAND 29 cd /home/ubuntu/My_website/my_blog_app/blog/ "
                 # ifconfig
                 # ip config
                 # ip
                 # python3 manage.py runserver 3.70.226.110:8000
# python3 manage.py runserver localhost:8000


############################################################################
# sudo pip3 install django gunicorn psycopg2-binary

# sudo pip3 install mysqlclient
# cd /home/ubuntu/My_website/my_blog_app/blog
# gunicorn --bind 0.0.0.0:8000 blog.wsgi
############################################################################

deactivate                                                      #### DONT NEED 
# echo "COMMAND 30 deactivate"
# echo "#########################################################################################################################################################"
# sudo apt install -y mysql-server 
# sudo pip3 install django gunicorn psycopg2-binary
# # cd ./blog
# sudo apt install -y libmysqlclient-dev default-libmysqlclient-dev
# sudo pip3 install wheel
# sudo pip3 install mysqlclient
# echo "#########################################################################################################################################################"

# python3 manage.py makemigrations
# python3 manage.py migrate
# sudo ufw allow 8000

sudo cp /home/ubuntu/My_website/services/gunicorn.socket /etc/systemd/system/gunicorn.socket
echo "COMMAND 31 sudo cp /home/ubuntu/My_website/services/gunicorn.socket /etc/systemd/system/gunicorn.socket"
sudo cp /home/ubuntu/My_website/services/gunicorn.service /etc/systemd/system/gunicorn.service
echo "COMMAND 32 sudo cp /home/ubuntu/My_website/services/gunicorn.service /etc/systemd/system/gunicorn.service"
# chown -R www-data:root ~/django_project
sudo chown -R www-data:ubuntu ~/My_website                            ##########    sudo chown -R www-data:root ~/ 
echo "COMMAND 33 sudo chown -R www-data:root ~/"
sudo systemctl daemon-reload
echo "COMMAND 34 sudo systemctl daemon-reload"
sudo systemctl start gunicorn.socket
echo "COMMAND 35 sudo systemctl start gunicorn.socket"
sudo systemctl enable gunicorn.socket
echo "COMMAND 36 sudo systemctl enable gunicorn.socket"
sudo systemctl daemon-reload
sudo systemctl restart gunicorn
sudo cp /home/ubuntu/My_website/nginx/django.conf /etc/nginx/sites-available/django.conf
echo "COMMAND 37 sudo cp /home/ubuntu/My_website/nginx/django.conf /etc/nginx/sites-available/django.conf"
sudo ln -s /etc/nginx/sites-available/django.conf /etc/nginx/sites-enabled
sudo systemctl restart nginx
echo "COMMAND 38 sudo systemctl restart nginx"
sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'

# sudo pip3 install django gunicorn psycopg2-binary

# sudo pip3 install mysqlclient

# gunicorn --bind 0.0.0.0:8000 blog.wsgi


