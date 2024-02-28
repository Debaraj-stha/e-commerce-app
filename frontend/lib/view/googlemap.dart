import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/googleModelView.dart';
import 'package:frontend/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final GoogleModelView _googleModelView = Get.find<GoogleModelView>();
  @override
  void initState() {
    // TODO: implement initState
    _googleModelView.addMarker();
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
        title: SearchBar(
          controller: _googleModelView.textEditingController,
          onChanged: (value) async {
            await _googleModelView.searchPlace(value);
          },
          onSubmitted: (value) {},
          hintText: "Search Address",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GoogleMap(
          initialCameraPosition: GoogleModelView.initialCameraPosition,
          mapType: MapType.normal,
          onTap: (position) {
            String myAddress =
                "lat=${position.latitude}&long=${position.longitude}";
            _googleModelView.conformDeliveryAddress(context, myAddress);
            Utils.printMessage("Tap detected");
          },
          onLongPress: (argument) {
            Utils.printMessage("Long pressed detected");
          },
          compassEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          buildingsEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapToolbarEnabled: true,
          cloudMapId: "1",
          markers: Set<Marker>.of(_googleModelView.markers),
          onMapCreated: (controller) {
            GoogleModelView().controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _googleModelView.moveToUserLocation();
        },
        child: const Icon(FontAwesomeIcons.locationArrow),
      ),
    );
  }
}
