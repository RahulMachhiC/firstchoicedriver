import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppGoogleMap extends StatefulWidget {
  const AppGoogleMap({
    required this.currentLocation,
    super.key,
    required this.markers,
    required this.polylines,
  });
  final LatLng currentLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  @override
  State<AppGoogleMap> createState() => _AppGoogleMapState();
}

class _AppGoogleMapState extends State<AppGoogleMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      myLocationEnabled: false,
      polylines: widget.polylines,
      markers: widget.markers,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (controller) {
        // setState(() {
        //   ismapCreated = true;
        // });
      },
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: widget.currentLocation,
        zoom: 15,
      ),
    );
  }
}
