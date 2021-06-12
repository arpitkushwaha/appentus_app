import 'dart:io';

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
  CameraPosition _initialCameraPosition;
  LatLng current_lat_long;
  Set<Marker> _markersSet = {};
  GoogleMapController _controller;
  Location _location = Location();
  LocationData current_location_data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialCameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocationData();
  }

  void getCurrentLocationData() async {
    current_location_data = await _location.getLocation();
    setState(() {
      current_lat_long = LatLng(
          current_location_data.latitude, current_location_data.longitude);
      _initialCameraPosition = CameraPosition(target: current_lat_long, zoom: 15.0);
      if (_controller != null)
        _controller
            .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));

      _markersSet.add(Marker(
        markerId: MarkerId("current"),
        position: current_lat_long,
        infoWindow: InfoWindow(
            title:
                '${current_lat_long.latitude}, ${current_lat_long.longitude}'),
      ));
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(_initialCameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments;

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(user),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [

              Align(
                alignment: Alignment.bottomCenter,
                child: _buildSecondScreenBtn(),
              ),

              _buildGoogleMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondScreenBtn() {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 180, height: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/second');
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(top: 6, left: 15, right: 15, bottom: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            primary: Colors.black,
            elevation: 5.0),
        child: Text(
          'Second Screen',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 600,
      ),
      child: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: _markersSet,
      ),
    );
  }
  
  Widget _buildAppBar(User user)
  {
   return AppBar(
      title: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: FileImage(File(user.image)),
              ),
            ],
          )
      ),
    );
  }
}
