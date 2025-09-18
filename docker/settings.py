import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DB'),
        'USER': os.getenv('POSTGRES_USER'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD'),
        'HOST': 'db',
        'PORT': 5432,
    }
}

SECRET_KEY = os.getenv('DJANGO_SECRET_KEY')
DEBUG = int(os.getenv('DEBUG', default=0))
ALLOWED_HOSTS = ['*']
