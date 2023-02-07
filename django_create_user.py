from django.contrib.auth.models import User

user=User.objects.create_user('admin', password='admin')
user.is_superuser=True
user.is_staff=True
user.save()