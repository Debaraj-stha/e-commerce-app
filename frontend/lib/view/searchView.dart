import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/model-view/searchModelView.dart';
import 'package:frontend/model/productModel.dart';
import 'package:frontend/model/searchModel.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/smallText.dart';
import 'package:frontend/resources/widget/buildSearchBar.dart';
import 'package:frontend/view/s.dart';
import 'package:get/get.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchModeView _searchModeView = Get.find<SearchModeView>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          BuildSearchBar("Search ...", context),
          Positioned(
            
              child: Container(
                margin: EdgeInsets.only(top: 10),
            height: _searchModeView.search.length * 120,
            color: AppColors.secondary,
            child: ListView.builder(
                itemCount: _searchModeView.search.length,
                itemBuilder: (context, index) {
                  final search = _searchModeView.search[index];
                  return InkWell(
                    onTap: () {
                    _searchModeView.getSpecificProduct(search.id);
                    Future.delayed(Duration(seconds: 1));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleProduct(product: _searchModeView.product!)));
                    },
                    child: BuildSearchItem(search, index.toString()));
                }),
          )),
        ],
      ),
    );
  }

  Widget BuildSearchItem(SearchProduct search, String index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.third))),
      child: ListTile(
        leading: Container(
          width: 60,
          child:  Image(
          image: NetworkImage(search.image),
          errorBuilder: (context, error, stackTrace) {
            return Center(child: MediumText(text: "error while loading image",),);
          },
          ),
        ),
        title: MediumText(
          text: search.title!.length>75?search.title!.substring(0,75):search.title,
        ),
     
        trailing: SmallText(
          text: "Rs:${search.price}",
        ),
      ),
    );
  }
}
