from django.contrib import admin
from django.urls import path
from myapp import views
from django.conf.urls.static import static
from django.conf import settings
from myapp.adminpannel import *

urlpatterns = [
    path("", views.loadTemplates),
    path("user/register", views.RegisterUser),
    path("category/product", views.getCategoryProduct),
    path("product/recommendation", views.getRecommission),
    path("send-email", views.sendOTP),
    path("user/login", views.Login),
    path("category/group", views.getAllCategory),
    path("product/search", views.getSearchElement),
    path("review/add", views.postReview),
    path("product/order", views.placeOrder),
    path("order/update", views.updateStatus),
    path("delivery-address/add", views.updateDeliveryAddress),
    path("product/low-budget", views.lowBudget),
    path("message/send", views.sendMessage),
    path("message/get", views.getMessage),
    path("product/single", views.getSingleProduct),
    path("product/reviews", views.getUserReviews),
    path("product/review/edit", views.updateReview),
    path("notification/send", views.sendNotification),
    path("user/notifications", views.getNotifications),
    path("notification/seen", views.updateToSeen),
    path("shop/message", views.getSingleShopMessage),
    path("owner/messages", getMyShopMessages),
    path("reply/message", replyMessage),
    path("send/reply", views.postReply),
    path("shop/orders", getShopOrders),
    path("shop/register", registerShop),
    path('register/shop',views.registerMyShop),
    path('verify-email', views.verifyOTP)
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
