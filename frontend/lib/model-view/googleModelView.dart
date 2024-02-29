import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/model/locationmodel.dart';
import 'package:frontend/utils/topLevelFunction.dart';
import 'package:frontend/utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../data/network/networkAPI.dart';
import '../resources/appURL.dart';

class GoogleModelView extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  TextEditingController addressingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String userId = "1";
  List places = [];
  static CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(26.824949, 87.275722), zoom: 14);
  final Completer<GoogleMapController> controller = Completer();
  final List<Marker> markers = [];
  Address dAddress = Address();
  final List<String> images = [
    "asset/images/ecommerce.png",
    "asset/images/shop1.png",
    "asset/images/shopping.png",
  ];
  final List<LatLng> _latLngs = [
    const LatLng(26.824949, 87.275722),
    const LatLng(26.2, 87.2),
    const LatLng(26.3, 87.3)
  ];
  final List<Marker> _markerList = [
    const Marker(
        markerId: MarkerId("1"),
        position: LatLng(26.824949, 87.275722),
        infoWindow: InfoWindow(title: "My location")),
    const Marker(
      markerId: MarkerId("2"),
      position: LatLng(37.212, 86.275722),
    )
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo framinfo = await codec.getNextFrame();
    return (await framinfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> addMarkers() async {
    markers.addAll(_markerList);
    for (var i = 0; i < images.length; i++) {
      final Uint8List icon = await getBytesFromAsset(images[i], 100);

      markers.add(Marker(
          icon: BitmapDescriptor.fromBytes(icon),
          position: _latLngs[i],
          markerId: MarkerId(i.toString()),
          infoWindow: InfoWindow(title: "Marker $i")));
    }
  }

  Future<void> movetToPosition(CameraPosition position) async {
    GoogleMapController myController = await controller.future;
    myController.animateCamera(CameraUpdate.newCameraPosition(position));
    update(); //move to the camera to given latitude and longitude
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission() //ask the permission for using location
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error: $error");
    });
    return await Geolocator
        .getCurrentPosition(); //return the user current latuitude and longitude
  }

  Future<void> searchPlaces(String q) async {
    String token = "1234";
    String key = "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$q&key=$key&sessiontoken=$token';
    final response = await http.get(Uri.parse(request));

    if (response.statusCode != 200) {
      print("response is not come from server");
      return;
    }
    var place = jsonDecode(response.body)['predictions'];
    places.clear();
    for (var p in place) {
      places.add(p);
    }
    if (q == '' || q.isEmpty) {
      update();
    }
    update();
    // if (q != " " || q.isNotEmpty) {
    //   setState(() {});
    //   print(places);
    // }
    print("places:$places");
  }

  Future<void> getLocationFromCoordnites(
      LatLng coord, BuildContext context) async {
    List<Placemark> places =
        await placemarkFromCoordinates(coord.latitude, coord.longitude);
    print(places);
    String a =
        "Street=${places[0].street}\ncountry=${places[0].country}\nLocality=${places[0].locality}\nsublocality=${places[0].subLocality}\nSubadministrative area=${places[0].subAdministrativeArea}\nlat=${coord.latitude}\nlong=${coord.longitude}";

    conformDeliveryAddress(context, a);
//  Name: R853+GX,
// I/flutter ( 1646):       Street: R853+GX,
// I/flutter ( 1646):       ISO Country Code: NP,
// I/flutter ( 1646):       Country: Nepal,
// I/flutter ( 1646):       Postal code: 56700,
// I/flutter ( 1646):       Administrative area: ,
// I/flutter ( 1646):       Subadministrative area: Sunsari,
// I/flutter ( 1646):       Locality: Dharan,
// I/flutter ( 1646):       Sublocality: Panchkanya,
// I/flutter ( 1646):       Thoroughfare: ,
// I/flutter ( 1646):       Subthoroughfare: ,       Name: R854+R45,
// I/flutter ( 1646):       Street: R854+R45,
// I/flutter ( 1646):       ISO Country Code: NP,
// I/flutter ( 1646):       Country: Nepal,
// I/flutter ( 1646):       Postal code: 56700,
// I/flutter ( 1646):       Administrative area: Koshi Province,
// I/flutter ( 1646):       Subadministrative area: Sunsari,
// I/flutter ( 1646):       Locality: Dharan,
// I/flutter ( 1646):       Sublocality: Panchkanya,
// I/flutter ( 1646):       Thoroughfare: ,
// I/flutter ( 1646):       Subthoroughfare: ,       Name: Unnamed Road,
// I/flutter ( 1646):       Street: Unnamed Road,
// I/flutter ( 1646):       ISO Country Code: NP,
// I/flutter ( 1646):       Country: Nepal,
// I/flutter ( 1646):       Postal code: 56700,
// I/flutter ( 1646):       Administrative area: ,
// I/flutter ( 1646):       Subadministrative area: Sunsari,
// I/flutter ( 1646):       Locality: Dharan,
// I/flutter ( 1646):       Sublocality: Panchkanya,
// I/flutter ( 1646):       Thoroughfare: Unnamed Road,
// I/flutter ( 1646):       Subthoroughfare: ,       Name: Panchkanya,
// I/flutter ( 1646):       Street: Panchkanya,
// I/flutter ( 1646):       ISO Country Code: NP,
    // List<PlaceMark>
  }

  conformDeliveryAddress(BuildContext context, String location) {
    dAddress.address = location;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Is this your delivery address",
              ),
              content: Text(location),
              actions: [
                TextButton(
                  child: const Text(
                    "Close",
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                    child: const Text(
                      "Yes",
                    ),
                    onPressed: () async {
                      await insertAddress(dAddress, context);
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

  Future<void> getSavedAddress() async {
    try {
      final res = await dbController.getAddress();
      dAddress.address = res!.address!;
      addressingController.text = dAddress.address!;
      Utils.printMessage(res.toJson().toString());
    } catch (e) {
      Utils.printMessage("Exception as:$e");
    }
  }

  Future<void> insertAddress(Address a, BuildContext context) async {
    try {
      final res = await dbController.insertAddress(a);
      if (res) {
        Utils().showSnackBar(
          "Delivery address added successfully",
          context,
        );
      } else {
        Utils().showSnackBar(
            "Something went wrong while adding delivery address", context,
            isSuccess: false);
      }
    } catch (e) {
      Utils.printMessage("Exceptions as :$e");
    }
  }

  Future<void> handleLocationSearchTap(
      String address, BuildContext context) async {
    dAddress.address = address;
    conformDeliveryAddress(context, address);
  }
}
