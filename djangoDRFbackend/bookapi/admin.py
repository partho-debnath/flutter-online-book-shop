from django.contrib import admin

from . models import *

# Register your models here.

class BookAdmin(admin.ModelAdmin):
    fields = ['name', 'edition', 'author', 'cover', 'description', 'price']
    list_display = ['name', 'edition', 'author', 'price', 'cover', 'cover_imgage_preview']
    readonly_fields = ['cover_imgage_preview', ]

admin.site.register(Book, BookAdmin)
admin.site.register(User)
admin.site.register(Cart)
admin.site.register(OrderId)
admin.site.register(Order)

