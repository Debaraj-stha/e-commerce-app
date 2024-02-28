import 'package:flutter/material.dart';
import 'package:frontend/model-view/messageView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/view/singleMessage.dart';
import 'package:get/get.dart';

import '../resources/components/bigText.dart';

class MyMessage extends StatefulWidget {
  const MyMessage({super.key});

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  final MessageViewMOdel _m = Get.find<MessageViewMOdel>();
  bool isSeen = true;
  String userId = "1";
  @override
  void initState() {
    // TODO: implement initState
    _m.getMyMessages(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: "Messages"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_m.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }
        if (_m.messages.isEmpty && _m.isLoading.isFalse) {
          return const Center(
            child: MediumText(
              text: "You do not have any message yet",
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _m.messages.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySingleShopMessage(
                                shopId: _m.messages[index].shop.id)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isSeen
                            ? AppColors.textColorPrimary
                            : AppColors.secondary),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: _m.messages[index].shop.name,
                            ),
                            MediumText(text: _m.messages[index].message),
                          ],
                        )),
                        Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textColorPrimary),
                            child: Icon(
                              Icons.check,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodySmall!
                                  .color!,
                            ))
                      ],
                    ),
                  ),
                );
              }),
        );
      }),
    );
  }
}
