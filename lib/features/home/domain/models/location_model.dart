import 'package:latlong2/latlong.dart';

class LocationModel {
  final String name;
  final String address;
  final LatLng position;

  LocationModel({
    required this.name,
    required this.address,
    required this.position,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['display_name'].split(',')[0],
      address: json['display_name'],
      position: LatLng(
        double.parse(json['lat']),
        double.parse(json['lon']),
      ),
    );
  }
}
