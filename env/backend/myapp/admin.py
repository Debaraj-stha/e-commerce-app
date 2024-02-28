from django.contrib import admin
from myapp import models

# Register your models here.
admin.site.register(models.User)
admin.site.site_header = "E-Commerce Admin panel"
admin.site.site_title = "E-commerce app"
admin.site.register(models.Produsts)
admin.site.register(models.Rating)
admin.site.register(models.Order)
admin.site.register(models.Message)
admin.site.register(models.Shop)
admin.site.register(models.Notification)
admin.site.register(models.UserNotification)
