import 'dart:async';

import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabPage extends StatelessWidget {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print("This is your Address :: " + address);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),
        Container(
          height: 140.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Positioned(
          top: 60.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    makeDriverOnlineNow();
                    getLocationLiveUpdates();
                  },
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Offline Now - Go Online ",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void makeDriverOnlineNow() async{

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.onValue.listen((event) {
      
    });
  }
  
  void getLocationLiveUpdates(){
    
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) { 
      currentPosition = position;
      Geofire.setLocation(currentfirebaseUser.uid, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
      
    });
  }
}
