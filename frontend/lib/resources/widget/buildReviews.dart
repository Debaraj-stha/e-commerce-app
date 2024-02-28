import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/resources/widget/buildNetworkImage.dart';
import 'package:get/get.dart';

import '../../model-view/reviewModelView.dart';
import '../../model/reviewModels.dart';
import '../../utils/utils.dart';
import '../appColors.dart';
import '../components/bigText.dart';
import '../components/mediumText.dart';

Widget BuildMyReviews(Reviews review, BuildContext context,
    {isFieldShow = false}) {
  ReviewModelView r = Get.find<ReviewModelView>();
  Utils u = Get.find<Utils>();

  return Obx(() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildNetworkImage(review.product!.image),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BigText(
                  text: review.product!.title!.length > 100
                      ? review.product!.title!.substring(0, 99)
                      : review.product!.title,
                ),
                MediumText(
                  text: review.feedback,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBarIndicator(
                        unratedColor:
                            Theme.of(context).primaryTextTheme.bodySmall!.color,
                        itemCount: 5,
                        // rating: review.rating,
                        itemSize: 16,
                        itemBuilder: (context, index) {
                          return const Icon(
                            Icons.star,
                            color: Colors.orange,
                          );
                        }),
                    MediumText(
                      text: review.created_at!.toString(),
                    )
                  ],
                ),
                AnimatedCrossFade(
                    firstChild: SizedBox(
                      width: Utils.getWidth(context) * 0.8,
                      child: TextFormField(
                        maxLines: 3,
                        focusNode: r.focusNode,
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                        onTapOutside: (event) {
                          // r.handleOutSideTap();
                        },
                        onFieldSubmitted: (value) {
                          r.updateReview(review.id!, context);
                        },
                        controller: r.reviewController,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                r.updateReview(review.id!, context);
                              },
                              child: Icon(
                                Icons.send_outlined,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 5, right: 5),
                            counterStyle:
                                Theme.of(context).primaryTextTheme.bodySmall,
                            hintStyle:
                                Theme.of(context).primaryTextTheme.bodySmall,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyLarge!
                                        .color!)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyLarge!
                                        .color!),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            hintText: "Feedback..."),
                      ),
                    ),
                    secondChild: Container(),
                    crossFadeState: r.isShown(review.id!)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 150)),
                IconButton(
                  tooltip: "Edit Review",
                  onPressed: () {
                    r.toggleIsShown(review.id!, review.feedback ?? "");
                    // Navigator.pushNamed(context, RoutesName.E);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ))
          ],
        ),
      ));
}
