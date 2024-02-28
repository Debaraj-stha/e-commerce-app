import 'package:flutter/material.dart';
import 'package:frontend/model-view/reviewModelView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/bigText.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';

import '../resources/widget/buildReviews.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  final ReviewModelView _review = Get.put(ReviewModelView());
  int userId = 2;
  @override
  void initState() {
    // TODO: implement initState

    loadReviews();
    super.initState();
  }

  loadReviews() async {
    await _review.loadReviews(userId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const BigText(
          text: "Reviews",
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            children: [
              if (_review.isLoading.isTrue)
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: Utils.getHeight(context) * 0.4,
                  ),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              if (_review.isLoading.isFalse && _review.reviews.isEmpty) ...[
                SizedBox(
                  height: Utils.getHeight(context) * 0.4,
                ),
                const Center(
                  child: MediumText(text: "You havenot reviewed any item yet"),
                ),
                TextButton(onPressed: () {}, child: const Text("Review Now"))
              ],
              if (_review.reviews.isNotEmpty)
                Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _review.reviews.length,
                      itemBuilder: (context, index) {
                        final review = _review.reviews[index];
                        return BuildMyReviews(review, context,
                            isFieldShow: true);
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
