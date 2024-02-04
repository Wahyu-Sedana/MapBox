import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:simple_mapbox/services/location_service.dart';

class UserLocationSymbol {
  static Future<void> addUserLocationSymbol(MapboxMapController mapController) async {
    try {
      var locationService = LocationService();
      var lat = await locationService.getLat();
      var long = await locationService.getLong();

      mapController.addSymbol(SymbolOptions(
        geometry: LatLng(lat, long),
        iconImage: 'assets/cars.png',
        iconSize: 2,
        textOffset: Offset(0, 2),
        textColor: '#ffffff',
        textSize: 12.0,
      ));
      // mapController.setSymbolIconAllowOverlap(true);
      // mapController.setSymbolIconIgnorePlacement(true);
      // mapController.setSymbolTextAllowOverlap(true);
      // mapController.setSymbolTextIgnorePlacement(true);
    } catch (e) {
      print('Error adding symbol: $e');
    }
  }
}
