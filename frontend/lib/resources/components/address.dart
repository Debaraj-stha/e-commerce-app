import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/resources/components/smallText.dart';
import 'package:get/get.dart';

class SearchedAddress extends StatefulWidget {
  const SearchedAddress({super.key});

  @override
  State<SearchedAddress> createState() => _SearchedAddressState();
}

class _SearchedAddressState extends State<SearchedAddress> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ListTile(
                leading: Icon(FontAwesomeIcons.locationArrow),
                title: MediumText(
                  text: "Dharan,Nepal",
                ),
                subtitle: SmallText(
                  text: "Bagarkot",
                ),
              );
            })));
  }
}
