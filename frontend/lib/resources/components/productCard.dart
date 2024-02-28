// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:frontend/model-view/cart-view.dart';
// import 'package:frontend/model/cartModel.dart';
// import 'package:frontend/model/productModel.dart';
// import 'package:frontend/resources/appColors.dart';
// import 'package:frontend/resources/components/buildIcon.dart';
// import 'package:frontend/resources/components/mediumText.dart';
// import 'package:frontend/resources/components/smallText.dart';
// import 'package:get/get.dart';

// class ProductCard extends StatelessWidget {
//   ProductCard(
//       {super.key,
//       required this.product,
//       this.isCartIcon = true,
//       this.isCategory = false,
//       this.isWishlistIcon = true});
//   final Products product;
//   final bool? isCartIcon;
//   final bool? isWishlistIcon;
//   final bool isCategory;
//   final CartModelView _cartModelView = Get.find<CartModelView>();
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       child: Container(
//         width: 160,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         decoration: BoxDecoration(
//             boxShadow: const [
//               BoxShadow(
//                   color: Colors.black,
//                   offset: Offset(5, 2),
//                   spreadRadius: 1,
//                   blurRadius: 5)
//             ],
//             borderRadius: BorderRadius.circular(10),
//             color: Theme.of(context).bottomNavigationBarTheme.backgroundColor),
//         margin: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 70,
//               height: 90,
//               child: Image(
//                 image: NetworkImage(product.image),
//                 fit: BoxFit.contain,
//                 errorBuilder: (context, error, stackTrace) {
//                   return const Image(
//                       image: AssetImage("asset/images/image5.jpeg"));
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 2,
//             ),
//             isCategory
//                 ? MediumText(
//                     text: product.category.length > 15
//                         ? product.category.substring(0, 15)
//                         : product.category,
//                   )
//                 : MediumText(
//                     text: product.title!.length > 15
//                         ? product.title!.substring(0, 15)
//                         : product.title,
//                   ),
//             const SizedBox(
//               height: 4,
//             ),
//             MediumText(
//               text: "Rs:${product.price.toString()}",
//             ),
//             const SizedBox(
//               height: 4,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 RatingBarIndicator(
//                     itemSize: 16,
//                     rating: product.average_rating!,
//                     unratedColor: Theme.of(context).primaryColorLight,
//                     // unratedColor: Colors.black,
//                     itemBuilder: (context, index) {
//                       return const Icon(
//                         Icons.star,
//                         color: Colors.orange,
//                       );
//                     }),
//                 Container(
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         size: 16,
//                         color: Colors.orange,
//                       ),
//                       SmallText(
//                         text: product.ratingCount.toString(),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 isCartIcon!
//                     ? IconButton.filled(
//                         disabledColor: AppColors.third,
//                         isSelected: false,
//                         highlightColor: AppColors.secondary,
//                         tooltip: "Add To Cart",
//                         onPressed: () {
//                           CartModel cartModel = CartModel(
//                               id: product.id,
//                               title: product.title!,
//                               category: product.category,
//                               image: product.image,
//                               average_rating: product.average_rating!,
//                               ratingCount: product.ratingCount!,
//                               price: product.price,
//                               shopId: product.shopId!,
//                               size: product.size![0] ?? "No size");
//                           Future.delayed(const Duration(seconds: 2));
//                           _cartModelView.addToCart(cartModel, context);
//                         },
//                         icon: const BuildIcon(
//                           icon: FontAwesomeIcons.cartPlus,
//                           size: 20,
//                         ),
//                       )
//                     : Container(),
//                 isWishlistIcon!
//                     ? IconButton.filled(
//                         disabledColor: AppColors.third,
//                         isSelected: false,
//                         hoverColor: AppColors.primary,
//                         color: AppColors.primary,
//                         splashColor: AppColors.third,
//                         autofocus: true,
//                         tooltip: "Add to Wishlist",
//                         onPressed: () {
//                           // _cartModelView.addToWishlist(product, context);
//                         },
//                         icon: const BuildIcon(
//                           icon: Icons.favorite_outline_outlined,
//                           size: 25,
//                         ),
//                       )
//                     : Container()
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
