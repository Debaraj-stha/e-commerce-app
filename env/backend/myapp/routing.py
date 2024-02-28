from django.urls import path
from myapp import consummer

websocket_urlPatterns = [path("ws/wc/", consummer.MyConsumer.as_asgi())]
