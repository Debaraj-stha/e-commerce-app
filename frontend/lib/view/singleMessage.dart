import 'package:flutter/material.dart';
import 'package:frontend/model-view/messageView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../resources/widget/buildmessage.dart';

class MySingleShopMessage extends StatefulWidget {
  const MySingleShopMessage({super.key, required this.shopId});
  final int shopId;
  @override
  State<MySingleShopMessage> createState() => _MySingleShopMessageState();
}

class _MySingleShopMessageState extends State<MySingleShopMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final MessageViewMOdel _m = Get.find<MessageViewMOdel>();
  final Utils _u = Get.find<Utils>();
  int userId = 1;
  @override
  void initState() {
    // _m.getShopMessage(widget.shopId, userId);
    _controller = AnimationController(vsync: this);
    _m.textEditingController.addListener(() {
      _u.cancelTimer();
    });
    _m.focusNode.addListener(() {
      if (_m.focusNode.hasFocus) {
        _u.startTimer(_m.focusNode);
      } else {
        _u.cancelTimer();
      }
    });
    super.initState();
    // Cancel the timer when text is changed

    // _messageViewModel.loadMessage();
    _m.getMyMessage(widget.shopId, userId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MediumText(text: "Shop Name"),
      ),
      body: Column(
        children: [
          Obx(() {
            if (_m.isLoading.isTrue) {
              return Container(
                padding: EdgeInsets.symmetric(
                    vertical: Utils.getHeight(context) * 0.37),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            } else {
              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _m.shopMessage.length,
                    itemBuilder: (context, index) {
                      final message = _m.shopMessage[index];
                      return BuildMessageWidget(message, context);
                    },
                  ),
                ),
              );
            }
          }),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              style: Theme.of(context).primaryTextTheme.bodySmall,
              onTapOutside: (event) {
                _m.focusNode.unfocus();
              },
              onFieldSubmitted: (value) {
                _m.handleSubmit();
              },
              onChanged: (value) {
                _m.handleChange(value, _u);
              },
              // controller: r.reviewController,
              focusNode: _m.focusNode,
              controller: _m.textEditingController,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                  child: Icon(
                    Icons.send,
                    color: AppColors.primary,
                  ),
                  onTap: () {},
                ),
                contentPadding: const EdgeInsets.only(left: 5, right: 5),
                counterStyle: Theme.of(context).primaryTextTheme.bodySmall,
                hintStyle: Theme.of(context).primaryTextTheme.bodySmall,
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryTextTheme.bodyLarge!.color!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryTextTheme.bodyLarge!.color!,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                hintText: "Message...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
