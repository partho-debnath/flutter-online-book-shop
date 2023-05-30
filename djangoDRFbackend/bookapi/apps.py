from django.apps import AppConfig


class BookapiConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'bookapi'
    verbose_name = "Book API"    # change app name in admin panel
