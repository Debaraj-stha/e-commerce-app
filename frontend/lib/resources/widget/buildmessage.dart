import 'package:flutter/material.dart';
import 'package:frontend/model/messageModel.dart';
import 'package:frontend/utils/utils.dart';
import 'package:intl/intl.dart';

import '../appColors.dart';

Widget BuildMessageWidget(Message message, BuildContext context) {
  print(message.receiverId);
  return Container(
    width: Utils.getWidth(context) * 0.7,
    alignment: message.isSender ? Alignment.centerLeft : Alignment.centerRight,
    child: Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.message,
            style: Theme.of(context)
                .primaryTextTheme
                .bodyMedium!
                .copyWith(color: AppColors.secondary),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            DateFormat('yyyy-MM-dd HH:mm').format(message.createdAt),
            style: Theme.of(context)
                .primaryTextTheme
                .bodySmall!
                .copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    ),
  );
}
