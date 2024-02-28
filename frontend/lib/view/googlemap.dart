import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/model-view/googleModelView.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:frontend/resources/components/mediumText.dart';
import 'package:frontend/utils/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogelMapPage extends StatefulWidget {
  const GoogelMapPage({super.key});

  @override
  State<GoogelMapPage> createState() => _GoogelMapPageState();
}

class _GoogelMapPageState extends State<GoogelMapPage> {
  final GoogleModelView _view = Get.find<GoogleModelView>();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List places = [];
  static CameraPosition cameraPosition =
      const CameraPosition(target: LatLng(26.824949, 87.275722), zoom: 14);
  final Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _markesr = [];
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
    _markesr.addAll(_markerList);
    for (var i = 0; i < images.length; i++) {
      final Uint8List icon = await getBytesFromAsset(images[i], 100);

      _markesr.add(Marker(
          icon: BitmapDescriptor.fromBytes(icon),
          position: _latLngs[i],
          markerId: MarkerId(i.toString()),
          infoWindow: InfoWindow(title: "Marker $i")));
    }
    setState(() {});
  }

  Future<void> movetToPosition(CameraPosition position) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        position)); //move to the camera to given latitude and longitude
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
      setState(() {});
    }
    setState(() {});
    // if (q != " " || q.isNotEmpty) {
    //   setState(() {});
    //   print(places);
    // }
    print("places:$places");
  }

  @override
  void initState() {
    // TODO: implement initState
    addMarkers();
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
          controller: _textEditingController,
          textStyle: MaterialStateProperty.all(
              Theme.of(context).primaryTextTheme.bodyMedium),
          focusNode: _focusNode,
          hintText: "Search here...",
          onChanged: (String value) async {
            await searchPlaces(value);
          },
          onSubmitted: (value) {
            _focusNode.unfocus();
          },
        ),
        toolbarHeight: 90,
      ),
      body: _textEditingController.text.isNotEmpty
          ? ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(FontAwesomeIcons.locationDot),
                  title: MediumText(text: places[index]['description']),
                  subtitle: MediumText(
                      text: places[index]['structured_formatting']
                          ['secondary_text']),
                );
              })
          : GoogleMap(
              markers: Set<Marker>.of(_markesr),
              myLocationEnabled: true,
              onMapCreated: (controller) {
                _controller.complete(controller);
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
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _textEditingController.text.isEmpty
          ? FloatingActionButton(
              onPressed: () async {
                //  movetToPosition(CameraPosition(target: LatLng(37.212, 86.275722)));
                getUserCurrentLocation().then((value) {
                  _markesr.add(Marker(
                      // infoWindow: const InfoWindow(title: "my current location"),
                      markerId: const MarkerId("3"),
                      infoWindow: const InfoWindow(
                        title: "My Location",
                      ),
                      position: LatLng(value.latitude, value.longitude)));
                  CameraPosition position = CameraPosition(
                      target: LatLng(value.latitude, value.longitude),
                      zoom: 14);
                  movetToPosition(position);
                });
                setState(() {});
              },
              child: const Icon(Icons.location_searching),
            )
          : Container(),
    );
  }
}
