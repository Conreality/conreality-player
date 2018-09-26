/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong/latlong.dart';

////////////////////////////////////////////////////////////////////////////////

class MapTab extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

////////////////////////////////////////////////////////////////////////////////

class MapState extends State<MapTab> {
  final MapController _controller = MapController();

  @override
  Widget build(final BuildContext context) {
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(center: LatLng(51.5, -0.09), zoom: 13.0), // TODO
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiYXJ0b2IiLCJhIjoiY2ptaXM5bzNjMDdraTNrcGZ2eW9pZThlNSJ9.mTZOp7pGeEqDgQdJQPVCRg',
            'id': 'mapbox.outdoors',
          },
        ),
        MarkerLayerOptions(
          markers: [],
        ),
      ],
    );
  }

  bool get ready => _controller.ready;
  LatLngBounds get bounds => _controller.bounds;
  LatLng get center => _controller.center;
  double get zoom => _controller.zoom;

  void centerAt(LatLng location, {double zoom = 13.0}) {
    _controller.move(location, zoom);
  }

  void fitBounds(LatLngBounds bounds, FitBoundsOptions options) {
    _controller.fitBounds(bounds, options: options);
  }
}
