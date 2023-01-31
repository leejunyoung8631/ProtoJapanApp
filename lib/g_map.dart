import 'dart:convert';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class WholeMap extends StatefulWidget {
  const WholeMap({super.key});

  // now no final fields from parent 
  // final ~

  @override 
  State<WholeMap> createState() => _WholeMapState();
}

class _WholeMapState extends State<WholeMap> {
  // now no fields.
  // const ~ 
  final Completer<GoogleMapController> _controller = Completer();
  // Completer는 비동기 처리에 사용된다는 것 같은데, 지금 당장 이해는 안돼...

  // CameraPosition
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(32.776665, -96.796989,), zoom: 10.0,);
  
  // methods
  // void ~

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        }
      ),
    );
  }
}