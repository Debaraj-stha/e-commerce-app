import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/utils/utils.dart';

import 'mediumText.dart';

class BuildTextField extends StatelessWidget {
  BuildTextField(
      {super.key,
      this.hint,
      this.label,
      this.suffix,
      this.prefix,
      required this.controller,
      required this.focusnode,
      required this.onSubmit,
      this.next,
      this.type,
      required this.onTapOutSide,
      this.isObsecure = false});
  final String? hint;
  final String? label;
  final Widget? prefix;
  final int? type;
  final Widget? suffix;
  final TextEditingController controller;
  final FocusNode focusnode;
  final Function onSubmit;

  final Function onTapOutSide;
  final bool? isObsecure;
  final FocusNode? next;
  TextInputType? textInputType;
  @override
  handleKeyBoardType() {
    switch (type) {
      case 1:
        textInputType = TextInputType.emailAddress;
        break;
      case 4:
        textInputType = TextInputType.phone;
        break;
      default:
        textInputType = TextInputType.text;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    handleKeyBoardType();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        style: Theme.of(context).primaryTextTheme.bodyMedium,
        keyboardType: textInputType,
        controller: controller,
        obscureText: isObsecure!,
        onFieldSubmitted: (value) {
          onSubmit(value);
          Utils.handleFocusNode(focusnode, next, context);
        },
        onTapOutside: (event) {
          onTapOutSide();
          focusnode.unfocus();
        },
        validator: (value) {
          return Utils.validator(value!, type!);
        },
        textCapitalization: TextCapitalization.words,
        autocorrect: true,
        autofocus: false,
        focusNode: focusnode,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: prefix,
          prefixIconColor: AppColors.primary,
          errorStyle: Theme.of(context)
              .primaryTextTheme
              .bodySmall!
              .copyWith(color: Colors.red),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          hintText: hint,
          label: MediumText(
            text: label,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
