import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/model/cartModel.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/widget/buildNetworkImage.dart';

import '../resources/appColors.dart';
import '../utils/utils.dart';

class GiveReview extends StatefulWidget {
  const GiveReview({super.key, required this.model});
  final CartModel model;
  @override
  State<GiveReview> createState() => _GiveReviewState();
}

class _GiveReviewState extends State<GiveReview> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: const BigText(
          text: "Add Review",
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: BuildNetworkImage(model.image)),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            BigText(
              text: model.title,
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: Utils().ratingValue,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.all(3),
              minRating: 1,
              itemSize: 18,
              unratedColor: AppColors.third,
              itemBuilder: (context, index) {
                return const Icon(
                  Icons.star,
                  color: Colors.orange,
                );
              },
              onRatingUpdate: (value) {
                Utils().handleRating(value);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 4,
              focusNode: Utils().focusNode,
              style: Theme.of(context).primaryTextTheme.bodyMedium,
              onTapOutside: (event) {
                Utils().handleTapOutside();
              },
              controller: Utils().reviewController,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  counterStyle: Theme.of(context).primaryTextTheme.bodySmall,
                  hintStyle: Theme.of(context).primaryTextTheme.bodyMedium,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  hintText: "Feedback..."),
            ),
            TextButton(
              child: const Text("POST"),
              onPressed: () {
                Utils().postReview("21", context);
              },
            )
          ],
        ),
      )),
    );
  }
}
