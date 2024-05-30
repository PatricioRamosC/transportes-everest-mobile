import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:transportes_everest_mobile/config/constants.dart';

import '../utils/utils.dart';

class MapScreen extends StatefulWidget {
  final LatLng source;
  final LatLng destination;
  final String informacionDestino;

  const MapScreen(
      {super.key,
      required this.source,
      required this.destination,
      required this.informacionDestino});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? currentLocation;
  List<LatLng> polylineCoordinates = [];
  Utils utils = Utils();

  void getCurrentLocation() async {
    return;
    Location location = Location();
    currentLocation = LatLng(widget.source.latitude, widget.source.longitude);
    location.getLocation().then((value) {
      currentLocation = LatLng(value.latitude ?? widget.source.latitude,
          value.longitude ?? widget.source.longitude);
    });
    location.onLocationChanged.listen((value) {
      setState(() {
        currentLocation = LatLng(value.latitude ?? widget.source.latitude,
            value.longitude ?? widget.source.longitude);
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          zoom: 3)));
    });
  }

  void getPolyPoints() async {
    List<PolylineWayPoint> puntos = [
      PolylineWayPoint(location: "(-33.46817828081213, -70.63785081440386)"),
      PolylineWayPoint(location: "(-33.4611446207962, -70.6332160987421)"),
      PolylineWayPoint(location: "(-33.449245385165966, -70.63898253024081)"),
    ];

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult results = await polylinePoints.getRouteBetweenCoordinates(
        Constants.googleApiKey,
        PointLatLng(widget.source.latitude, widget.source.longitude),
        PointLatLng(widget.destination.latitude, widget.destination.longitude),
        wayPoints: List<PolylineWayPoint>.generate(3, (index) {
          return puntos[index];
        }));
    if (results.points.isNotEmpty) {
      setState(() {
        for (PointLatLng element in results.points) {
          polylineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.mapaTitulo),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: widget.source,
          zoom: 12.0,
        ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("polylineId"),
              points: polylineCoordinates,
              color: Colors.cyan,
              width: 5)
        },
        markers: {
          // Marker(
          //   markerId: const MarkerId(Constants.mapaMarkerId),
          //   position: LatLng(
          //       currentLocation?.latitude ?? widget.source.latitude,
          //       currentLocation?.longitude ?? widget.source.longitude),
          //   infoWindow: const InfoWindow(
          //     title: Constants.mapaMarkerTituloYo,
          //   ),
          // ),
          Marker(
            markerId: const MarkerId(Constants.mapaMarkerId),
            position: widget.source,
            infoWindow: const InfoWindow(
              title: Constants.mapaMarkerTituloOrigen,
            ),
          ),
          Marker(
            markerId: const MarkerId(Constants.mapaMarkerId),
            position: widget.destination,
            infoWindow: InfoWindow(
              title: Constants.mapaMarkerTituloDestino,
              snippet: widget.informacionDestino,
            ),
          ),
        },
        compassEnabled: true,
        mapToolbarEnabled: true,
        myLocationButtonEnabled: true,
        // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
        //     southwest: widget.source, northeast: widget.destination)),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _navigateToDestination();
      //   },
      //   child: const Icon(Icons.directions),
      // ),
    );
  }

  void _navigateToDestination() async {
    GoogleMapController controller = mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: widget.destination,
        zoom: 14,
      ),
    ));
  }
}
