import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/googleModelView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogelMapPage extends StatefulWidget {
  const GoogelMapPage({super.key});

  @override
  State<GoogelMapPage> createState() => _GoogelMapPageState();
}

class _GoogelMapPageState extends State<GoogelMapPage> {
  final GoogleModelView _view = Get.find<GoogleModelView>();

  @override
  void initState() {
    // TODO: implement initState
    _view.addMarkers();
    _view.getSavedAddress();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColorPrimary,
        title: SearchBar(
          controller: _view.textEditingController,
          textStyle: MaterialStateProperty.all(
              Theme.of(context).primaryTextTheme.bodyMedium),
          focusNode: _view.focusNode,
          hintText: "Search here...",
          onChanged: (String value) async {
            await _view.searchPlaces(value);
          },
          onSubmitted: (value) {
            _view.focusNode.unfocus();
          },
        ),
        toolbarHeight: 90,
      ),
      body:
          // Obx(() {
          //   Utils.printMessage(_view.textEditingController.text);
          //   return
          _view.textEditingController.text.isNotEmpty
              ? ListView.builder(
                  itemCount: _view.places.length,
                  itemBuilder: (context, index) {
                    final place = _view.places[index];
                    return ListTile(
                      onTap: () {
                        String address =
                            "address=${place['description']}\nsecondary_address=${place['structured_formatting']['secondary_text']}";
                        _view.handleLocationSearchTap(address, context);
                      },
                      leading: const Icon(FontAwesomeIcons.locationDot),
                      title: MediumText(text: place['description']),
                      subtitle: MediumText(
                          text: place['structured_formatting']
                              ['secondary_text']),
                    );
                  })
              : GoogleMap(
                  markers: Set<Marker>.of(_view.markers),
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    _view.controller.complete(controller);
                  },
                  onLongPress: (position) {
                    Utils.printMessage("long press is detected");
                  },
                  onTap: (argument) {
                    Utils.printMessage("tap is detected");
                    _view.getLocationFromCoordnites(argument, context);
                  },
                  onCameraMove: (position) {
                    Utils.printMessage("camera moving");
                  },
                  onCameraMoveStarted: () {},
                  onCameraIdle: () {},
                  initialCameraPosition: GoogleModelView.cameraPosition,
                  mapType: MapType.normal,
                ),
      // }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _view.textEditingController.text.isEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await _view.getSavedAddress();
                // _view.getUserCurrentLocation().then((value) {
                //   _view.markers.add(Marker(
                //       markerId: const MarkerId("3"),
                //       infoWindow: const InfoWindow(
                //         title: "My Location",
                //       ),
                //       position: LatLng(value.latitude, value.longitude)));
                //   CameraPosition position = CameraPosition(
                //       target: LatLng(value.latitude, value.longitude),
                //       zoom: 14);
                //   _view.movetToPosition(position);
                // });
                // setState(() {});
              },
              child: const Icon(Icons.location_searching),
            )
          : Container(),
    );
  }
}
