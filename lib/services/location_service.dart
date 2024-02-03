import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<String> getCordinate() async {
    if (await _checkLocationPermission()) {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = new Coordinates(position.latitude, position.longitude);

      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var alamat = addresses.first;

      return alamat.addressLine.toString();
    } else {
      throw PermissionDeniedException();
    }
  }

  Future<double> getLat() async {
    if (await _checkLocationPermission()) {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = position.latitude;

      return coordinates;
    } else {
      throw PermissionDeniedException();
    }
  }

  Future<double> getLong() async {
    if (await _checkLocationPermission()) {
      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = position.longitude;

      return coordinates;
    } else {
      throw PermissionDeniedException();
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        return true;
      }
    }
    return false;
  }
}

class PermissionDeniedException implements Exception {
  final String message = 'Location permission denied';
}
