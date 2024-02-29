import logging
from django.conf import settings

from myapp.models import Rating
from django.db.models import Avg
from django.core.mail import send_mail
from cryptography.fernet import Fernet


def getProducts(products) -> list:
    recommended = []
    for product in products:
        ratings = Rating.objects.filter(product=product)
        shop = {}
        shopId = product.shopId
        shop = {
            "id": shopId.id,
            "name": shopId.name,
            "address": shopId.address,
            "phone": shopId.phone,
        }

        recommended.append(
            {
                "shop": shop,
                "id": product.id,
                "title": product.title,
                "category": product.category,
                "image": product.image,
                "price": product.price,
                "delivery_charge": product.delivery_charge,
                "hilights": product.hilight,
                "size": product.size,
                "description": product.description,
                "average_rating": product.avg_rating if product.avg_rating else 0,
                "tags": product.tags if product.tags else [],
                "brand": product.brand,
                "reviews": (
                    [
                        {
                            "rating": rating.rating,
                            "feedback": rating.feedback,
                            "created_at": rating.created_at,
                            "user": getUserMap(rating.user),
                        }
                        for rating in ratings
                    ]
                    if ratings
                    else []
                ),
                "ratingCount": len(ratings),
            }
        )
    recommended.sort(key=lambda x: x["average_rating"], reverse=True)
    return recommended


def sendMail(subject, body, mailTo) -> int:
    print("calling sendMail")
    mailFrom = settings.EMAIL_HOST_USER
    print(mailFrom)
    status = send_mail(subject, body, mailFrom, [mailTo],fail_silently=False,html_message=body)
    return int(status)


def encrypt(pas):
    try:
        f = Fernet(settings.ENCRYPTION_KEY)
        print(pas.encode())
        encrypted_msg = f.encrypt(pas.encode())
        return encrypted_msg
    except Exception as e:
        logging.error(f"An error occurred during encryption: {e}")
        return None


def decrypt(password):
    try:
        f = Fernet(settings.ENCRYPTION_KEY)
        print(f)
        print("before  decrypt  " + str(password))
        decrypted_message = f.decrypt(password)
        print("after decrypt" + str(decrypted_message))
        decodeMSG = decrypted_message.decode("utf-8")
        return decodeMSG
    except Exception as e:
        logging.error(f"An error occurred during decryption: {e}")
        return None


def getProductMap(product) -> dict:
    return {
        "id": product.id,
        "title": product.title,
        "category": product.category,
        "image": product.image,
        "price": product.price,
        "delivery_charge": product.delivery_charge,
        "description": product.description,
    }


def getUserMap(user) -> dict:
    return {
        "name": user.name,
        "id": user.id,
        "phone": user.phone,
        "image": user.image.url if user.image else None,
        "email": user.email,
    }
