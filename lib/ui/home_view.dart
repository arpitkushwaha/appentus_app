import 'package:appentus_app/logic/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeView extends StatefulWidget {

  const HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  CameraPosition _cameraPosition;
  LatLng current_lat_long;
  Set<Marker> _markers = {};
  GoogleMapController _controller;
  Location _location = Location();
  LocationData current_location_data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocationData();
  }

  void getCurrentLocationData() async {
    current_location_data = await _location.getLocation();
    setState(() {
      current_lat_long = LatLng(
          current_location_data.latitude, current_location_data.longitude);
      _cameraPosition = CameraPosition(target: current_lat_long, zoom: 15.0);
      if (_controller != null)
        _controller
            .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

      _markers.add(Marker(
        markerId: MarkerId("current"),
        position: current_lat_long,
        infoWindow: InfoWindow(
          title: '${current_lat_long.latitude}, ${current_lat_long.longitude}'
        ),
      ));
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {

    User user = ModalRoute.of(context).settings.arguments;
    print("Image: ${user.image}, Name: ${user.name}");

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 150,height: 50),
                  child: ElevatedButton(
                    onPressed:(){
                      Navigator.pushNamed(context, '/second');
                    },
                    child: Text(
                      'Second Screen'
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 100,
                  ),
                child: GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  markers: _markers,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
