import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
const apiKey= "AIzaSyB-fN1NQ93OrL5vhBf5QH9y9phrc1ErGi8";
class GoogleMapsServices{
Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async{
  String url= "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
  print("daman "+url);
http.Response response= await http.get(url);
Map values = jsonDecode(response.body);
return values['routes'][0]["overview_polyline"]['points'];
}
}