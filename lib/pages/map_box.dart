import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:simple_mapbox/widgets/mapbox_screen.dart';

class SimpleMapBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Simple MapBox'),
        ),
        body: MapBoxScreen());
  }
}
