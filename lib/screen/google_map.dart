import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyHome extends StatefulWidget {
  final double lat;
  final double long;

  MyHome(this.lat, this.long);

  @override
  _MyAppState createState() => _MyAppState(lat,long);
}

class _MyAppState extends State<MyHome> {
  LatLng _officeLatLng;
  _MyAppState(lat, long){
    _officeLatLng = LatLng(lat, long);
  }

  List<Marker> markers = [];
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
          markerId: MarkerId("myLocation"),
          draggable: false,
          onTap: () {
            print("My Location Tapped");
          },
          position: _officeLatLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Google Map"),
          backgroundColor: Colors.green[700],
        ),
        body: _googleMap(context),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _officeLatLng, zoom: 15.0),
        mapType: MapType.normal,
        markers: Set.from(markers),
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapToolbarEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
