import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/model/locationmodel.dart';
import 'package:frontend/resources/components/boldText.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../data/network/networkAPI.dart';
import '../resources/appURL.dart';

class GoogleModelView extends GetxController {
  static LatLng target = const LatLng(27.708215, 85.321317);
  String userId = "1";
  Address? dAddress;
  final List<Marker> markers = [];
  List<dynamic> places = [];
  static CameraPosition initialCameraPosition = CameraPosition(
    zoom: 14,
    target: target,
  );

  Future<Uint8List> loadIcon() async {
    final ByteData data =
        await rootBundle.load("asset/images/splash_srceen.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo frame = await codec.getNextFrame();
    return (await frame.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final Completer<GoogleMapController> controller = Completer();
  Future<void> moveToPosition(CameraPosition position) async {
    GoogleMapController mycontroller = await controller.future;
    mycontroller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<Position?> getUserCurrentPosition() async {
    final permission = await Geolocator.isLocationServiceEnabled();
    if (!permission) {
      final status = await Geolocator.requestPermission();
      if (status == LocationPermission.denied) {
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } else {
      return await Geolocator.getCurrentPosition();
    }
  }

  Future<void> moveToUserLocation() async {
    final userPosition = await getUserCurrentPosition();
    Utils.printMessage(userPosition.toString());
    Marker marker = Marker(
        markerId: const MarkerId("2"),
        visible: true,
        icon: BitmapDescriptor.defaultMarker,
        position: LatLng(userPosition!.latitude, userPosition.longitude));
    markers.add(marker);
    CameraPosition newPosition = CameraPosition(
        target: LatLng(userPosition.latitude, userPosition.longitude),
        zoom: 14);
    await moveToPosition(newPosition);
    update();
  }

  addShopMarker(List<LatLng> position) async {
    for (var i = 0; i < position.length; i++) {
      Marker marker = Marker(
          markerId: MarkerId('$i'),
          position: position[i],
          icon: BitmapDescriptor.fromBytes(await loadIcon()));
      markers.add(marker);
    }
  }

  searchPlace(String value) async {
    String token = "1234";
    String key = "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$value&key=$key&sessiontoken=$token';
    final response = await http.get(Uri.parse(request));
    if (response.statusCode != 200) {
      print("response is not come from server");
      return;
    }
    var place = jsonDecode(response.body.toString())['predictions'];
    if (value != " " || value.isNotEmpty) {
      update();
      print(places);
    }
  }

  final TextEditingController textEditingController = TextEditingController();

  List<LatLng> position = [
    const LatLng(26.794386, 87.281731),
    const LatLng(26.794386, 87.23434),
    const LatLng(26.794386, 87.281721)
  ];

  void addMarker() {
    addShopMarker(position);
  }

  Future<void> getLocationFromCoordnites(LatLng coord) async {
    // List<PlaceMark>
  }

  conformDeliveryAddress(BuildContext context, String location) {
    dAddress!.address = location;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const BoldText(
                text: "Is this your delivery address",
              ),
              content: MediumText(text: location),
              actions: [
                TextButton(
                  child: const MediumText(
                    text: "Close",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const MediumText(
                      text: "Yes",
                    ),
                    onPressed: () async {
                      await dbController.insertAddress(dAddress!);
                      await updateDeleveryAddress();
                      Navigator.of(context).pop();
                    })
              ],
            ));
  }

  Future<void> updateDeleveryAddress() async {
    try {
      Map<String, dynamic> data = {"userId": userId, "address": dAddress};
      final res = await NetworkAPI().postRequest(AppURL.updateAddress, data);
      String status = res['status'];
      String message = res['message'];

      Utils.printMessage(message);
    } catch (e) {
      Utils.printMessage("Exception:$e");
    }
  }
}
