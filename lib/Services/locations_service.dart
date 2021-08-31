import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations_service.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);

  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double lat;
  final double lng;
}

@JsonSerializable()
class Region {
  Region({
    this.coords,
    this.id,
    this.name,
    this.zoom,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);

  final LatLng coords;
  final String id;
  final String name;
  final double zoom;
}

@JsonSerializable()
class HeroStation {
  HeroStation({
    this.address,
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.region,
  });

  factory HeroStation.fromJson(Map<String, dynamic> json) =>
      _$HeroStationFromJson(json);

  Map<String, dynamic> toJson() => _$HeroStationToJson(this);

  final String address;
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String region;
}

@JsonSerializable()
class Locations {
  Locations({
    this.heroStations,
    this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<HeroStation> heroStations;
  final List<Region> regions;
}

Future<Locations> getHeroStations() async {
  //temporarily
  //will be changed to Cloud Firestore
  const heroStationLocations =
      'https://my-json-server.typicode.com/alihansoykal/we/db';

  final response = await http.get(heroStationLocations);
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(heroStationLocations));
  }
}
