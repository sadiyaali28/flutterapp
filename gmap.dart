import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sample_app/stations.dart';
import 'package:location/location.dart';
import 'package:sample_app/requests.dart';


class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);
  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  
  bool mapToggle = false;
  var currentLocation;
  LatLng cur;
  Set<Circle> _circles = HashSet<Circle>();
  GoogleMapsServices _googleMapServices= GoogleMapsServices();
  final Set<Polyline> _polyLines= {};

GoogleMapController mapController;
List<Marker> allMarkers= [];
PageController _pageController;
BitmapDescriptor _markerIcon;
int prevPage;
Marker marker;
Circle circle;
var location;
LatLng saved;
Location _locationTracker= Location();
StreamSubscription _locationSubscription;
Future<Uint8List> getMarker() async{
  ByteData byteData= await DefaultAssetBundle.of(context).load("assets/images/taxi.png");
  return byteData.buffer.asUint8List();
}

void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData){
  LatLng latlng= LatLng(newLocalData.latitude, newLocalData.longitude);
  this.setState(() {
    marker= Marker(
      markerId: MarkerId('23'),
      position: latlng,
      rotation: newLocalData.heading,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      icon: BitmapDescriptor.fromBytes(imageData)
    );
    allMarkers.add(marker);
  _circles.add(Circle(
  circleId: CircleId("taxi"),
  radius: 5000,
  zIndex: 1,
  strokeColor: Colors.blue,
  center: latlng,
  fillColor: Colors.blue.withAlpha(70)
  ));
  });
}

void getCurrentLocation() async{
  try{
    Uint8List imageData= await getMarker();
    location= await _locationTracker.getLocation();

    updateMarkerAndCircle(location, imageData);

    if(_locationSubscription != null){
      _locationSubscription.cancel();
    }

    _locationSubscription= _locationTracker.onLocationChanged().listen((newLocalData) {
      if(mapController != null){
        mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          bearing: 192.83349011395799,
          target: LatLng(newLocalData.latitude, newLocalData.longitude),
          tilt: 0,
          zoom: 12.00
        )));
        updateMarkerAndCircle(newLocalData, imageData);
      }
    });

  } on PlatformException catch (e){
    if(e.code == 'PERMISSION_DENIED'){
      debugPrint("Permission Denied");
    }
  }
}


@override
  void initState(){
    super.initState();
    _setMarkerIcon();
    getCurrentLocation();
   Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation= currloc;
        cur= LatLng(currloc.latitude, currloc.longitude);
        mapToggle= true;
        chargingStations.forEach((element) {
           location= _locationTracker.getLocation();
          Geolocator()
          .distanceBetween(currentLocation.latitude, currentLocation.longitude,
           element.locationCoords.latitude, element.locationCoords.longitude).then((calDist){
             if(calDist/1000 < 5){
               allMarkers.add(Marker(
      markerId: MarkerId(element.stationName),
      draggable: false,
      position: element.locationCoords,
      infoWindow: InfoWindow(title: element.description),
    icon: _markerIcon,
    onTap: () {
      saved= LatLng(element.locationCoords.latitude, element.locationCoords.longitude);
     sendRequest();
     _tripEditModalBottomSheet(context);
    },
    ));
             }
           });
    
  });
      });
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),

      ),
      body:
       Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height - 80.0,
                width: double.infinity,
                child: mapToggle
                ? GoogleMap(
                  
                  zoomGesturesEnabled: true,
                  onMapCreated: onMapCreated,
                  
                  initialCameraPosition: CameraPosition(target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 12.0,
                  
                  ),
                  markers: Set.from(allMarkers),
                  circles: _circles,
                  polylines: _polyLines,
                  
                  )
                : Center(child: 
                Text("Loading...Please Wait",
                style: TextStyle(
                  fontSize: 20.0
                ),)
                )
              ),
            ],
          )
        ],
      )
    );
  }

   void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      
    });
  }

moveCamera(){
  mapController.animateCamera(CameraUpdate.newCameraPosition(
    CameraPosition(
      target: chargingStations[_pageController.page.toInt()].locationCoords,
      zoom: 14.0,
      bearing: 45.0,
      tilt: 45.0
    )
  ));
}

void _setMarkerIcon() async {
    _markerIcon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/icon.png');

}

List<LatLng> convertToLatLng(List points){
  List<LatLng> result= <LatLng>[];
  for(int i=0; i<points.length; i++){
    if(i%2 != 0){
      result.add(LatLng(points[i-1], points[i]));
    }
  }
  return result;
}

List decodePoly(String poly){
  var list = poly.codeUnits;
  var lList= new List();
  int index=0;
  int len= poly.length;
  int c=0;
  do{
    var shift= 0;
    int result=0;
    do{
      c= list[index]-63;
      result |= (c&0x1F)<<(shift*5);
      index++;
      shift++;
    }
    while(c>=32);
    if(result & 1==1){
      result=~ result;
    }
    var result1 = (result>>1)*0.00001;
    lList.add(result1);
    }while(index<len);
    for(var i=2; i<lList.length; i++)
      lList[i]+=lList[i-2];
    print(lList.toString());
    return lList;
  }

  void sendRequest() async{
    String route= await _googleMapServices.getRouteCoordinates(cur, saved);
    _createRoute(route);
  }

  void _createRoute(String encodedPolyline){
    setState(() {
      _polyLines.add(Polyline(
        polylineId: PolylineId("routes"),
        width: 10,
        color: Colors.black,
        points: convertToLatLng(decodePoly(encodedPolyline)),
      ));
    });
  }

}

void _tripEditModalBottomSheet(context){
  showModalBottomSheet(context: context, builder: (BuildContext bc){
    return Container(
      height: MediaQuery.of(context).size.height*.50,
      child:Padding(padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(''),
              Spacer(),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.orange, size: 25),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      )
      ),
  );
  });
}





