import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:simple_mapbox/services/location_service.dart';

class MapBoxScreen extends StatefulWidget {
  @override
  State<MapBoxScreen> createState() => _MapBoxScreenState();
}

class _MapBoxScreenState extends State<MapBoxScreen> {
  final String ACCESS_TOKEN =
      "sk.eyJ1Ijoid3NzdHVkaW8iLCJhIjoiY2xzMTh2c2FtMDkzczJqcXgzd2QzdTNmNCJ9.agjMnxCoT_IQvSqUzB96ZA";
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
      isLoading = false;
    });
    _addUserLocationSymbol();
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

  Future<void> _addUserLocationSymbol() async {
    try {
      var locationService = LocationService();
      var lat = await locationService.getLat();
      var long = await locationService.getLong();

      mapController
          .addSymbol(SymbolOptions(geometry: LatLng(lat, long), iconImage: 'assets/users.png'));
    } catch (e) {
      print('Error adding symbol: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        if (isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
