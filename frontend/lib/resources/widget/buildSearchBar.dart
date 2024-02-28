import 'package:flutter/material.dart';
import 'package:frontend/model-view/searchModelView.dart';
import 'package:get/get.dart';

Widget BuildSearchBar(String hint, BuildContext context) {
  SearchModeView searchModeView = Get.find<SearchModeView>();
  return SearchBar(
    controller: searchModeView.controller,
    
    hintText: hint,
    textCapitalization: TextCapitalization.words,
    textStyle: MaterialStateProperty.all(
        Theme.of(context).primaryTextTheme.bodyMedium),
    focusNode: searchModeView.focusNode,
    onChanged: (value) {
      searchModeView.handleChange(value,context);
    },
    onSubmitted: (val) {
      searchModeView.handleSubmit(val);
    },
  );
}
