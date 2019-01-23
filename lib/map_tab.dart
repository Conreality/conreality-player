/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'src/api.dart' as API;

////////////////////////////////////////////////////////////////////////////////

class MapTab extends StatefulWidget {
  MapTab({Key key, this.info}) : super(key: key);

  final API.GameInformation info;

  @override
  State<MapTab> createState() => MapState();
}

////////////////////////////////////////////////////////////////////////////////

class MapState extends State<MapTab> {
  final MapController _controller = MapController();

  @override
  Widget build(final BuildContext context) {
    final API.GameInformation info = widget.info;
    final LatLng origin = LatLng(info.origin.latitude, info.origin.longitude);
    return FlutterMap(
      mapController: _controller,
      options: MapOptions(center: origin, zoom: 15.0),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiYXJ0b2IiLCJhIjoiY2ptaXM5bzNjMDdraTNrcGZ2eW9pZThlNSJ9.mTZOp7pGeEqDgQdJQPVCRg', // TODO: make this configurable
            'id': 'mapbox.outdoors',
          },
        ),
        MarkerLayerOptions(
          markers: <Marker>[
            // The origin marker (using a home icon, for now):
            Marker(
              point: origin,
              width: 40.0,
              height: 40.0,
              builder: (context) => Container(child: Icon(Icons.home, color: Colors.black)),
            ),
            // TODO: Compass
          ],
        ),
        CircleLayerOptions(
          circles: <CircleMarker>[
            // The border for the game theater (a circular shape only, for now):
            CircleMarker(
              point: origin,
              radius: info.radius, // FIXME: https://github.com/johnpryan/flutter_map/pull/213
              color: Colors.blue.withOpacity(0.1),
              borderColor: Colors.red.withOpacity(1.0),
              borderStrokeWidth: 0.1, // FIXME: no effect?
            ),
          ],
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
