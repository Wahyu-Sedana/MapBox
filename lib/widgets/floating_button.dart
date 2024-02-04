import 'package:flutter/material.dart';

class FabHelper {
  static Widget buildFabs(
      BuildContext context, Function() zoomIn, Function() zoomOut, Function() gps) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: zoomIn,
            tooltip: 'Max',
            child: Icon(Icons.add, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: zoomOut,
            tooltip: 'Min',
            child: Icon(Icons.remove, color: Colors.black),
          ),
        ),
        FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: gps,
          tooltip: 'GPS',
          child: Icon(Icons.gps_fixed, color: Colors.black),
        ),
      ],
    );
  }
}
