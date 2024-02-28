import datetime
import json

from django.db import models
from django.contrib.postgres.fields import ArrayField
from django.dispatch import receiver
from django.forms import ValidationError
from django.core.validators import RegexValidator
from myapp.serverKey import SERVERKEY

from myapp.enumData import PAYMENT_METHOD, STATUS_CHOICES, PaymentMethod, Status
from . import consummer
from django.db.models.signals import post_save
from asgiref.sync import async_to_sync
from django.core.serializers.json import DjangoJSONEncoder
import requests

name_Validator = RegexValidator(
    regex=r"[a-zA-Z]", message="Invalid field value,only string is allowed"
)
phone_regex = RegexValidator(
    regex=r"^\+?1?\d{9,15}$",
    message="Phone number must be entered in the format: '+999999999'. Up to 13 digits allowed.",
)


class User(models.Model):

    name = models.CharField(max_length=150, validators=[name_Validator])
    password = models.CharField(max_length=150)
    email = models.EmailField(max_length=100, null=True)
    image = models.FileField(upload_to="image/", null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, null=True)
    phone = models.CharField(
        max_length=13, null=True, validators=[phone_regex], blank=True
    )
    address = models.TextField(max_length=255, null=True, blank=True)

    def __str__(self):
        return self.name


class Shop(models.Model):
    name = models.CharField(max_length=100, null=False)
    address = models.TextField(null=False)
    phone = models.CharField(max_length=13, validators=[phone_regex])

    def __str__(self):
        return self.name


class Produsts(models.Model):
    title = models.CharField(max_length=255, null=False)
    category = models.CharField(max_length=120, null=False)
    image = models.CharField(max_length=255)
    price = models.DecimalField(decimal_places=2, max_digits=10)
    size = ArrayField(models.CharField(), null=True, blank=True)
    hilight = ArrayField(models.TextField(null=True, blank=True), null=True, blank=True)
    delivery_charge = models.DecimalField(decimal_places=2, max_digits=5, default=00)
    description = models.TextField(null=True, blank=True)
    tags = ArrayField(
        models.CharField(null=True, blank=True, max_length=50), null=True, blank=True
    )
    brand = models.CharField(max_length=100, null=True, blank=True)
    shopId = models.ForeignKey(Shop, on_delete=models.CASCADE, default=1)
    # def __str__(self):
    #     return self.title


class Rating(models.Model):
    feedback = models.CharField(max_length=255, null=True, blank=True)
    rating = models.DecimalField(
        default=0,
        decimal_places=1,
        max_digits=5,
    )
    product = models.ForeignKey(
        Produsts,
        on_delete=models.CASCADE,
        null=False,
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False)
    created_at = models.DateTimeField(auto_now_add=True, null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True, null=True, blank=True)

    def __str__(self):
        return ("%s %s %s") % (self.rating, self.feedback, self.user.name)

    def clean(self):
        if not (0 <= self.rating <= 5):
            raise ValidationError("Rating must be between 0 and 5.")


class Order(models.Model):
    status = models.CharField(
        max_length=20, choices=STATUS_CHOICES, default=Status.PENDING
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True, null=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True, null=True, blank=True)
    payment_method = models.CharField(
        max_length=50, choices=PAYMENT_METHOD, default=PaymentMethod.CASH
    )
    product = models.ForeignKey(
        Produsts, on_delete=models.CASCADE, null=True, blank=True
    )
    quantity = models.IntegerField(default=1, null=True, blank=True)
    shop=models.ForeignKey(Shop, on_delete=models.CASCADE,null=True,blank=True)

    def __str__(self) -> str:
        return self.user.name

    def clean(self):
        if self.quantity is None or self.quantity < 1 or self.quantity > 10:
            raise ValidationError("Quantity must be between 1 and 10.")


class Message(models.Model):
    message = models.TextField(null=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)
    isSender = models.BooleanField(default=True, null=True, blank=True)
    phoneId = models.TextField(null=True, blank=True)

    def __str__(self):
        return self.message


class Notification(models.Model):
    title = models.CharField(max_length=255)
    subTitle = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    imageURL = models.ImageField(
        upload_to="notification_images/", null=True, blank=True
    )

    def __str__(self):
        return self.title


class UserNotification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    notification = models.ForeignKey(Notification, on_delete=models.CASCADE)
    seen = models.BooleanField(default=False)
    seen_at = models.DateTimeField(null=True, blank=True)

    def maek_seen(self):
        self.seen = True
        self.seen_at = datetime.timezone.now()
        self.save()


@receiver(post_save, sender=Message)
def sendMessage(sender, instance, created, **kwargs):
    if created and instance.isSender:
        message = {
            "id": instance.id,
            "message": instance.message,
            "created_at": instance.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "updated_at": instance.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
            "receiverId": instance.user.id,
            "isSeen": True,
            "isSender": instance.isSender,
            "user": {
                "id": instance.user.id,
            },
            "shop": {
                "id": instance.shop.id,
            },
            "type": "msg",
        }
        data = {
            "to": instance.phoneId,
            "data": message,
            "notification": {
                "title": "You have message from  e-commerce app",
                "body": instance.message,
            },
        }
        sendNotification(data)


@receiver(post_save, sender=Notification)
def send_notification_message(sender, instance, created, **kwargs):
    if created:
        print("Signal handler triggered for new Notification instance.")
        text_data = {
            "id": instance.id,
            "title": instance.title,
            "subTitle": instance.subTitle,
            "created_at": instance.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            "imageURL": (
                instance.imageURL.url
                if instance.imageURL and instance.imageURL.url
                else None
            ),
            "isSeen": False,
            "type": "notification",
            "id": "testid",
        }
        data = {
            "to": "/topics/notification",
            "notification": {
                "title": instance.title,
                "body": instance.subTitle,
                "image_url": "https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                "image": "https://images.pexels.com/photos/1391498/pexels-photo-1391498.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
            },
            "data": text_data,
        }
        sendNotification(data)


def sendNotification(data):
    try:
        r = requests.post(
            "https://fcm.googleapis.com/fcm/send",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"key={SERVERKEY}",
            },
            data=json.dumps(data),
        )
        if r.status_code == 200:

            print("notification send successfully")
        else:
            print("notification send failed")
    except Exception as e:
        print(f"Execption occured:{e}")
