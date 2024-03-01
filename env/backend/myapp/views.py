from email import message
import json
import random

from django.http import JsonResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from myapp.utils import (
    getProducts,
    getUserMap,
    sendMail,
    getProductMap,
)
from datetime import timedelta
from django.utils import timezone
from myapp.models import User

from django.db.models import Avg, Q, Max
from myapp.models import *
import logging
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from django.core.mail import send_mail

def loadTemplates(request):
    return render(request, "index.html")


@api_view(["POST"])
def RegisterUser(request):
    try:
        data = request.data
        email = data.get("email")
        phone = data.get("phone")
        name = data.get("name")
        password = data.get("password")
        phoneToken = data.get("phoneToken")
        user = User.objects.filter(email=email).first()
        print("user  " + str(user))
        if user is None:
            print(name, email, phone, password)
            new_user = User(
                phoneToken=phoneToken,
                name=name,
                email=email,
                password=password,
                phone=phone,
            )
            new_user.save()
            return JsonResponse(
                {
                    "status": "Success",
                    "message": "Registration successful",
                    "data": {
                        "id": new_user.id,
                        "name": name,
                        "email": email,
                        "password": password,
                        "phone": phone,
                    },
                },
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "Fail",
                    "message": "Email already exists",
                },
                status=401,
            )
    except Exception as e:
        print(e)
        return JsonResponse(
            {"status": "Fail", "message": f"Exception occurred: {e}"}, status=500
        )


logger = logging.getLogger(__name__)


@api_view(["POST"])
def Login(request):
    try:
        data = request.data
        email = data.get("email")
        password = data.get("password")

        user = User.objects.filter(email=email).first()
        print("user password" + str(user.password))
        if user is not None:
            if password == user.password:
                return JsonResponse(
                    {
                        "status": "Success",
                        "message": "Login successful",
                        "data": {
                            "id": user.id,
                            "name": user.name,
                            "password": user.password,
                            "email": user.email,
                            "phone": user.phone,
                        },
                    },
                    status=200,
                )
            else:
                return JsonResponse(
                    {
                        "status": "Fail",
                        "message": "Invalid credentials",
                    },
                    status=401,
                )
        else:
            return JsonResponse(
                {
                    "status": "Fail",
                    "message": "Email not found",
                },
                status=404,
            )
    except Exception as e:
        logger.error(f"An error occurred during login: {e}")
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occurred: {e}",
            },
            status=500,
        )


@api_view(["POST"])
def sendOTP(request):
    try:
        mailto = request.data.get("mailTo")
        sessionKey = request.data.get("sessionKey")
        otp = random.randint(100000, 999999)
        subject = "Account verification code"
        message = f"Verify your account with this otp.This otp will expire  after 5 minutes.<br><strong>{otp}</strong>"
        
        status = sendMail(subject,message,mailto)

        if status == 1:
            request.session[sessionKey] = otp
            request.session.set_expiry(300)
            return JsonResponse(
                {
                    "status": True,
                    "key":sessionKey,
                    "message": "verification code sent successfully",
                },
                status=200
                
            )
        else:
            return JsonResponse(
                {
                    "status": False,
                    "message": "Something went wrong.verification code  does not sent.",
                },
                status=400,
            )
    except Exception as e:
        print(e)
        return JsonResponse(
            {"status": False, "message": f"Exception occured while sending email:{e}"},
            status=500,
        )


@api_view(["GET"])
def getRecommendation(request):
    try:
        limit = int(request.GET.get("limit", 10))
        offset = int(request.GET.get("offset", 0))
        totalData = Products.objects.count()
        start_index = offset
        end_index = offset + limit
        products =  Products.objects.annotate(avg_rating=Avg('rating__rating')).order_by('-avg_rating')[start_index:end_index]
        print(products)
        recommended = getProducts(products)

        if recommended is not None:
            return JsonResponse(
                {
                    "status": "success",
                    "message": "Recommended products",
                    "data": recommended,
                    "length": totalData,
                    "page": offset,
                },
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "Fail",
                    "message": "No Item found",
                },
                status=404,
            )

    except Exception as e:
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["GET"])
def getAllCategory(request):
    limit = int(request.GET.get("limit"))
    offset = int(request.GET.get("offset"))
    try:

        categories_with_products = (
            Products.objects.values("category", "id", "title", "price", "image")
            .distinct("category")
            .order_by("category")
        )

        grouped_products = []
        for product_info in categories_with_products:
            ratings = Rating.objects.filter(product=product_info["id"])
            print(ratings)
            average_rating = ratings.aggregate(avg_rating=Avg("rating"))["avg_rating"]
            category = product_info["category"]
            product_data = {
                "id": product_info["id"],
                "title": product_info["title"],
                "price": product_info["price"],
                "image": product_info["image"],
                "category": category,
                #     "rating":[{
                #     "rating":rating.rating,
                #     "feedback":rating.feedback
                # } for rating in ratings],
                "average_rating": average_rating if average_rating else 0,
                "ratingCount": len(ratings),
            }
            grouped_products.append(product_data)

        return JsonResponse(
            {
                "status": "success",
                "message": "One product from each category",
                "data": grouped_products,
            },
            status=200,
        )

    except Exception as e:
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occurred: {e}",
            },
            status=500,
        )


@api_view(["GET"])
def getCategoryProduct(request):
    try:
        data = request.GET
        category = data.get("category")
        limit = int(data.get("limit", 10))
        offset = int(data.get("offset", 0))
        startIndex = offset
        endIndex = offset + limit
        products = Products.objects.filter(category=category)[startIndex:endIndex]
        res = getProducts(products)
        if res is not None:
            return JsonResponse(
                {"status": "success", "message": "category products", "data": res},
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "fail",
                    "message": "No item found",
                },
                status=404,
            )

    except Exception as e:
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["GET"])
def getSearchElement(request):
    try:
        query = request.GET.get("q").lower()
        products = Products.objects.filter(
            Q(title__contains=query)
            | Q(tags__contains=[query])
            | Q(brand__contains=query)
            | Q(category__contains=query)
        )
        res = getProducts(products)
        if res is not None:
            return JsonResponse(
                {"status": "success", "message": "category products", "data": res},
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "fail",
                    "message": "Search item is not found",
                },
                status=404,
            )
    except Exception as e:
        return JsonResponse(
            {
                "status": "fail",
                "message": f"Internal server Error:{e}",
            },
            status=500,
        )


@api_view(["POST"])
def postReview(request):

    try:
        data = request.data
        userId = int(data.get("userId"))
        rating = float(data.get("rating"))
        feedback = data.get("feedback")
        productId = int(data.get("productId"))
        user = User.objects.filter(id=userId).first()

        p = Products.objects.all()

        product = Products.objects.filter(id=productId).first()

        if user is not None and product is not None:
            Rate = Rating(rating=rating, user=user, product=product, feedback=feedback)
            Rate.save()
            if Rate.save:
                return JsonResponse(
                    {
                        "status": "Success",
                        "message": "Reviews posted successfully",
                    },
                    status=200,
                )
        return JsonResponse(
            {
                "status": "Fail",
                "message": "Eiter user or product is noot found",
            },
            status=404,
        )
    except Exception as e:
        print(e)
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["POST"])
def placeOrder(request):

    try:
        data = request.data
        data = data.get("data")
        data = json.loads(data)
        userId = int(data[0]["userId"])
        user = User.objects.filter(id=userId).first()
        userEmail=user.email
        isSuccessful = True
        for item in data:
            product = Products.objects.filter(id=19).first()
            print("product" + str(product))
            if user is not None or product is not None:
                order = Order(
                    quantity=item["quantity"],
                    user=user,
                    payment_method=item["payment"],
                    product=product,
                )
                order.save()
                isSuccessful = True
            else:
                isSuccessful = False
        if isSuccessful:
            subject="Ordre conformation"
            body=f"Your order has been placed successfully.Your order will be delivered to your address {user.address} within {order.created_at + timedelta(days=1)}-{order.created_at+timedelta(day=4)}"
            status = sendMail(subject,body,userEmail)
            return JsonResponse(
                {
                    "status": "success",
                    "message": "Order placed successfully",
                    "orderId": order.id,
                },
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "fail",
                    "message": "Either user or product is not found",
                },
                status=401,
            )

    except Exception as e:
        print(e)
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["POST"])
def updateStatus(request):
    try:
        data = request.data
        oredrId = int(data.get("orderId"))
        status = data.get("status")
        order = Order.objects.filter(id=oredrId).first()
        if order is not None:
            order.status = status
            order.save()
            return JsonResponse(
                {
                    "status": "Success",
                    "message": "Status updated successfully",
                },
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": "Fail",
                    "message": "Inavlid order id.Order not found",
                },
                status=404,
            )
    except Exception as e:
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["POST"])
def updateDeliveryAddress(request):
    try:
        data = request.data
        userId = int(data.get("userId"))
        address = data.get("address")
        user = User.objects.filter(id=userId).first()

        if user is not None:
            user.address = address
            user.save()
            return JsonResponse(
                {
                    "status": "Success",
                    "message": "Delivery address updated successfully",
                },
                status=500,
            )
        else:
            return JsonResponse(
                {
                    "status": "Fail",
                    "message": "User not found",
                },
                status=404,
            )

    except Exception as e:
        return JsonResponse(
            {
                "status": "Fail",
                "message": f"Exception occured:{e}",
            },
            status=500,
        )


@api_view(["GET"])
def lowBudget(request):
    try:
        limit = int(request.GET.get("limit", 10))
        offset = int(request.GET.get("offset", 0))
        startIndex = offset
        endIndex = offset + limit
        products = Products.objects.annotate(avg_rating=Avg('rating__rating')).order_by("price")[
            startIndex:endIndex
        ]  # Order by price in ascending order
        res = getProducts(products)
        res.sort(key=lambda x:x['price'])
        return JsonResponse(
            {"status": "success", "message": "Data loaded successfully", "data": res},
            status=200,
        )
    except Exception as e:
        return JsonResponse(
            {"status": "fail", "message": f"Exception occurred: {e}"}, status=500
        )


@api_view(["POST"])
def sendMessage(request):
    try:
        data = request.data
        shopId = int(data.get("shopId"))
        userId = int(data.get("userId"))
        message = data.get("message")
        user = User.objects.filter(id=userId).first()
        shop = Shop.objects.filter(id=shopId).first()
        if user is not None and shop is not None:
            m = Message(message=message, user=user, shop=shop)
            m.save()
            return JsonResponse(
                {"status": "success", "message": "Message sent successfully"},
                status=200,
            )
        else:
            return JsonResponse(
                {"status": "fail", "message": "Either shop or user is not found"},
                statud=401,
            )
    except Exception as e:
        return JsonResponse(
            {"status": "fail", "message": f"Exception occured:{e}"}, status=500
        )


@api_view(["GET"])
def getMessage(request):
    try:
        userId = int(request.GET.get("userId"))
        user = User.objects.filter(id=userId).first()

        if user is None:
            return JsonResponse(
                {"status": False, "message": "User not found"}, status=404
            )

        latest_messages = (
            Message.objects.filter(user=user)
            .values("shop")
            .annotate(latest_message=Max("created_at"))
            .order_by()
        )
        messages = []
        for latest_message in latest_messages:
            message = (
                Message.objects.select_related("user", "shop")
                .filter(
                    user=user,
                    shop=latest_message["shop"],
                    created_at=latest_message["latest_message"],
                )
                .first()
            )
            if message:
                messages.append(
                    {
                        "id": message.id,
                        "message": message.message,
                        "created_at": message.created_at,
                        "updated_at": message.updated_at,
                        "receiverId": message.user.id,
                        "isSeen": True,
                        "isSender": message.isSender,
                        "user": {
                            "id": message.user.id,
                            "username": message.user.name,
                        },
                        "shop": {
                            "id": message.shop.id,
                            "name": message.shop.name,
                            "address": message.shop.address,
                            "phone": message.shop.phone,
                        },
                    }
                )

        if messages:
            return JsonResponse(
                {
                    "status": True,
                    "message": "Latest messages loaded successfully",
                    "data": messages,
                },
                status=200,
            )
        else:
            return JsonResponse(
                {
                    "status": False,
                    "message": "No latest messages available for this user",
                    "data": [],
                },
                status=404,
            )

    except Exception as e:
        return JsonResponse(
            {"status": "fail", "message": f"Exception occurred: {e}"}, status=500
        )


@api_view(["GET"])
def getSingleProduct(request):
    try:
        productId = int(request.GET.get("productId"))
        product = Products.objects.filter(id=productId)
        data = getProducts(product)
        return JsonResponse(
            {"status": "success", "message": "product get successfully", "data": data},
            status=200,
        )
    except Exception as e:
        return JsonResponse(
            {"status": "fail", "message": f"Exception occurred: {e}"}, status=500
        )


@api_view(["GET"])
def getUserReviews(request):
    try:
        userId = int(request.GET.get("userId"))
        user = User.objects.filter(id=userId).first()
        reviews = Rating.objects.filter(user=user)
        myReviws = []
        for review in reviews:
            myReview = {
                "id": review.id,
                "rating": review.rating,
                "feedback": review.feedback,
                "created_at": review.created_at,
                "user": getUserMap(review.user),
                "product": getProductMap(review.product),
            }
            myReviws.append(myReview)

        return JsonResponse(
            {
                "status": "success",
                "message": "Reviesw load successfully",
                "data": myReviws,
            },
            status=200,
        )
    except Exception as e:
        print(f"Exception  ${e}")
        return JsonResponse(
            {"status": "fail", "message": f"Exception occurred: {e}"}, status=500
        )


@api_view(["POST"])
def updateReview(request):
    try:
        data = request.data
        reviewId = int(data.get("reviewId"))
        feedback = data.get("feedback")
        review = Rating.objects.filter(id=reviewId).first()
        if review is not None:
            review.feedback = feedback
            review.save()
            return JsonResponse(
                {"status": "success", "message": "feedback updated successfully"},
                status=200,
            )
        else:
            return JsonResponse(
                {"status": "fail", "message": "Invalid review id"}, status=404
            )
    except Exception as e:
        print(f"Exception ${e}")
        return JsonResponse(
            {"status": "fail", "message": f"Exception occurred: {e}"}, status=500
        )


@api_view(["GET"])
def getNotifications(request):
    limit = int(request.GET.get("limit", 10))
    offset = int(request.GET.get("offset", 0))
    userId = int(request.GET.get("userId"))
    start_index = offset
    end_index = offset + limit
    notifications = Notification.objects.all()[start_index:end_index]
    notificationsList = []
    user = User.objects.get(id=userId)
    print(user)
    for notification in notifications:
        userNotification = UserNotification.objects.filter(
            user=user, notification=notification
        ).first()
        notif = {
            "id": notification.id,
            "isSeen": userNotification.seen if userNotification is not None else False,
            "title": notification.title,
            "subTitle": notification.subTitle,
            "created_at": notification.created_at,
            "imageURL": (
                notification.imageURL.url
                if notification.imageURL and notification.imageURL.url
                else None
            ),
        }
        notificationsList.append(notif)

    return JsonResponse(
        {
            "status": True,
            "message": "Notifications loaded  successfully",
            "data": notificationsList,
        }
    )


@api_view(["POST"])
def updateToSeen(request):
    try:
        data = request.data
        userId = int(data.get("userId"))
        notificationId = int(data.get("notificationId"))
        user = User.objects.filter(id=userId).first()
        notification = Notification.objects.filter(id=notificationId).first()
        if user is not None and notification is not None:
            userNotification = UserNotification(
                user=user, notification=notification, seen=True
            )
            userNotification.save()
            return JsonResponse(
                {"status": True, "message": "Notification seen successfully"}
            )
    except Exception as e:
        return JsonResponse({"status": False, "message": f"Exception occured:{e}"})


@api_view(["GET"])
def getSingleShopMessage(request):
    try:
        data = request.GET
        userId = int(data.get("userId"))
        shopId = int(data.get("shopId"))
        user = User.objects.filter(id=userId).first()
        shop = Shop.objects.filter(id=shopId).first()
        instances = Message.objects.filter(user=user, shop=shop)
        messages = []
        for instance in instances:
            messages.append(
                {
                    "id": instance.id,
                    "message": instance.message,
                    "created_at": instance.created_at,
                    "updated_at": instance.updated_at,
                    "receiverId": instance.user.id,
                    "isSeen": True,
                    "isSender": instance.isSender,
                    "user": {
                        "id": instance.user.id,
                    },
                    "shop": {
                        "id": instance.shop.id,
                    },
                }
            )
        return JsonResponse(
            {"status": True, "message": "Single Shop Message", "data": messages}
        )
    except Exception as e:
        return JsonResponse({"status": False, "message": f"Exception:{e}"})



@csrf_exempt
def postReply(request):
    if request.method == 'POST':
        isSender = False
        data = json.loads(request.body)
        message = data.get("message")
        shopId = data.get("shopId")
        userId = data.get("userId")
        if not shopId or not userId:
            return JsonResponse({"message": "shopId or userId is missing"}, status=400)
        
        try:
            shopId = int(shopId)
            userId = int(userId)
        except ValueError:
            return JsonResponse({"message": "Invalid shopId or userId"}, status=400)
        
        shop = Shop.objects.filter(id=shopId).first()
        user = User.objects.filter(id=userId).first()
        
        if not shop or not user:
            return JsonResponse({"message": "Shop or User not found"}, status=404)
        
        messageInstance = Message(isSender=isSender, message=message, user=user, shop=shop)
        messageInstance.save()
        
        return JsonResponse({"message": "Message successfully sent", "status": True}, status=200)
    else:
        return JsonResponse({"message": "Only POST requests are allowed"}, status=405)

l=logging.getLogger(__name__)
@csrf_exempt
def registerMyShop(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            name = data.get('name')
            address = data.get('address')
            phone = data.get('phone')
            instance=Shop.objects.filter(phone=phone).exists()
            if instance:
                l.error("Shop already exist.Login successfull")
                return JsonResponse({"status": False, "message": "Login successfull"}, status=400)
            shop=Shop(name=name, address=address, phone=phone)
            shop.save()
            return JsonResponse({"status": True, "message": "Shop is registered successfully"}, status=200)
        except Exception as e:
            l.exception(e)
            return JsonResponse({"status": False, "message": f"Exception: {e}"}, status=500)
    else:
        return JsonResponse({"message": "Only POST requests are allowed","status":False}, status=405)

@api_view(['POST'])
def verifyOTP(request):
    try:
        data=request.data
        sessionKey=data.get('sessionKey')
        serverOTP=request.session.get(sessionKey)
        email=data.get('email')
        otp=int(data.get('otp'))
        if otp==serverOTP:
            subject="Registration successfull"
            body=f"Welcome to our  shopping  platform,Mrs/Mr{sessionKey}.Enjoy your shopping experience"
            sendMail(subject,body,email)
            return JsonResponse({"status": True, "message": "OTP verified successfully"}, status=200)
        else:
            return JsonResponse({"status": False, "message": "OTP not verified.Please try gaian"}, status=400)
    except Exception as e:
        l.exception(e)
        return JsonResponse({"status": False, "message": f"Exception: {e}"}, status=500)
    