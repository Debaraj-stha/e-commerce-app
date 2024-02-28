from django.shortcuts import render
from django.core.paginator import Paginator
from myapp.models import Shop, Message, Order


def getMyShopMessages(request):
    shopId = int(request.GET.get("shopId"))
    page_number = int(request.GET.get("page", 1))  # default to page 1 if not specified
    items_per_page = int(request.GET.get("items", 1))
    shop = Shop.objects.filter(id=shopId).first()
    messages = Message.objects.filter(shop=shop)
    paginator = Paginator(messages, items_per_page)
    page_obj = paginator.get_page(page_number)
    return render(request, "messages.html", {"page_obj": page_obj})


def replyMessage(request):
    messageId = int(request.GET.get("message_id"))
    userId = int(request.GET.get("user_id"))
    shopId = int(request.GET.get("shop_id"))
    return render(request, "reply_message.html")


def getShopOrders(request):
    page = int(request.GET.get("page",1))
    
    shopId=int(request.GET.get("shopId"))
    shop=Shop.objects.filter(id=shopId).first()
    order = Order.objects.filter(shop=shop)
    items_per_page = 7
    paginator = Paginator(order, items_per_page)
    page_obj = paginator.get_page(page)
    return render(request, "orders.html", {"page_obj": page_obj})

def registerShop(request):
    return render(request, "register_shop.html")
