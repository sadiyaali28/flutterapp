import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station{
  String stationName;
  String description;
  LatLng locationCoords;

  Station({
    this.stationName,
    this.locationCoords,
    this.description,
    
  });
}

final List<Station> chargingStations= [
  Station(
    stationName: 'Mahindra Logistics Ltd',
    locationCoords: LatLng(12.839266, 77.685982),
    description: 'Mahindra Logistics Ltd',
    
  ),
  Station(
    stationName: 'Mahindra Reva Solar Charging Station',
    locationCoords: LatLng(12.810525, 77.662289),
    description: 'Mahindra Reva Solar Charging Station',
    
  ),
  Station(
    stationName: 'Fast charging by Mahindra Electric-2',
    locationCoords: LatLng(12.973561, 77.728046),
    description: 'Fast charging by Mahindra Electric-2',
    
  ),
  Station(
    stationName: 'Electric Vehicle Charging Station',
    locationCoords: LatLng(12.900340, 77.648576),
    description: 'Electric Vehicle Charging Station',
    
  
  ),
  Station(
    stationName: 'Mahindra Electric Fast Charger',
    locationCoords: LatLng(12.966276, 77.598890),
    description: 'Mahindra Electric Fast Charger',
  ),
  Station(
    stationName: 'kasheer',
    locationCoords: LatLng(34.115535, 74.806310),
    description: 'kasheer'
  )
];