import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:simple_mapbox/services/location_service.dart';
import 'package:simple_mapbox/services/userLocationSymbol_service.dart';

import 'floating_button.dart';

class MapBoxScreen extends StatefulWidget {
  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  late MapboxMapController mapController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;
      UserLocationSymbol.addUserLocationSymbol(mapController);
      isLoading = false;
    });
  }

  Future<void> _getUserLocation() async {
    try {
      await LocationService().getCordinate();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Failed to get location. Please make sure location permission is granted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: Future.wait([LocationService().getLat(), LocationService().getLong()]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MapboxMap(
                  // accessToken: ACCESS_TOKEN,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(snapshot.data![0], snapshot.data![1]), zoom: 15.0),
                );
              } else {
                return Container();
              }
            },
          ),
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(15.0),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
      floatingActionButton: FabHelper.buildFabs(
          context,
          () => mapController.animateCamera(CameraUpdate.zoomIn()),
          () => mapController.animateCamera(CameraUpdate.zoomOut()),
          () => LocationService.centerMapOnUser(mapController)),
    );
  }
}
