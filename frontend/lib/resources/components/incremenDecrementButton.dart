import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/utils/utils.dart';

import '../../utils/topLevelFunction.dart';
import '../appColors.dart';
import 'boldText.dart';

class IncrementDecreent extends StatefulWidget {
  const IncrementDecreent(
      {super.key, required this.oldCount, required this.itemId});
  final int oldCount;
  final int itemId;
  @override
  State<IncrementDecreent> createState() => _IncrementDecreentState();
}

class _IncrementDecreentState extends State<IncrementDecreent> {
  @override
  void initState() {
    // TODO: implement initState

    print("item id ${widget.itemId}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String itemId = widget.itemId.toString();
    return Container(
      width: Utils.getWidth(context) * 0.4,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
              stream: isDisabledStream,
              builder: ((context, snapshot) {
                int itemCount =
                    productCout[widget.itemId.toString()] ?? widget.oldCount;
                return InkWell(
                  onTap: () {
                    print(snapshot.data);
                    if (snapshot.data == null ||
                        snapshot.data[itemId] == false ||
                        snapshot.data[itemId] == null) {
                      incrementDecrement(
                        itemId,
                        itemCount,
                        1,
                        context,
                      );
                    }
                  },
                  child: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: AppColors.secondary,
                  ),
                );
              })),
          StreamBuilder(
              stream: stream,
              builder: ((context, snapshot) {
                Color color = Theme.of(context).scaffoldBackgroundColor;
                print("snapshot${snapshot.data}");
                return snapshot.hasData
                    ? Text(
                        snapshot.data[itemId] == null
                            ? "1"
                            : snapshot.data[itemId].toString(),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium!
                            .copyWith(
                                color: AppColors.textColorPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                      )
                    : Text(
                        widget.oldCount.toString(),
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium!
                            .copyWith(
                                color: AppColors.textColorPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                      );
              })),
          StreamBuilder(
              stream: incrementControllerstream,
              builder: ((context, snapshot) {
                int itemCount =
                    productCout[widget.itemId.toString()] ?? widget.oldCount;
                return InkWell(
                  onTap: () {
                    print(snapshot.data);
                    if (snapshot.data == null ||
                        snapshot.data[itemId] == false ||
                        snapshot.data[itemId] == null) {
                      incrementDecrement(
                        itemId,
                        itemCount,
                        0,
                        context,
                      );
                    }
                  },
                  child: Icon(
                    Icons.add_circle,
                    size: 30,
                    color: AppColors.secondary,
                  ),
                );
              })),
        ],
      ),
    );
  }
}
