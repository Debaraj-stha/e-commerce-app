import json
from asgiref.sync import async_to_sync

from channels.generic.websocket import WebsocketConsumer


class MyConsumer(WebsocketConsumer):
    def connect(self):
        self.room_name = "django"
        self.room_group_name = "django_group"
        print("connection established")

        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name, self.channel_name
        )

        self.accept()
        self.send(text_data=json.dumps({"payload": "this is a response from server"}))

        pass

    def disconnect(self, close_code):
        self.send({"type": "websocket.disconnect", "test": "disconnect "})
        print("close code is  " + str(close_code))
        pass

    def receive(self, text_data):
        print("received message is " + text_data)
        self.send(text_data="Received data is " + text_data)
        async_to_sync(self.channel_layer.group_send)(
            self.room_group_name,
            {
                "type": "chat.message",
                "text": text_data,
            },
        )

    def chat_message(self, event):
        print("chat messag is called")
        eventType = event["type"]
        text_data = event["text"]
        print(f"event ${str(event)}")
        self.send(text_data=text_data)
