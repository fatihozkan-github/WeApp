// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

Region _$RegionFromJson(Map<String, dynamic> json) {
  return Region(
    coords: json['coords'] == null
        ? null
        : LatLng.fromJson(json['coords'] as Map<String, dynamic>),
    id: json['id'] as String,
    name: json['name'] as String,
    zoom: (json['zoom'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'coords': instance.coords,
      'id': instance.id,
      'name': instance.name,
      'zoom': instance.zoom,
    };

HeroStation _$HeroStationFromJson(Map<String, dynamic> json) {
  return HeroStation(
    address: json['address'] as String,
    id: json['id'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    lng: (json['lng'] as num)?.toDouble(),
    name: json['name'] as String,
    region: json['region'] as String,
  );
}

Map<String, dynamic> _$HeroStationToJson(HeroStation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'region': instance.region,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) {
  return Locations(
    heroStations: (json['heroStations'] as List)
        ?.map((e) =>
            e == null ? null : HeroStation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    regions: (json['regions'] as List)
        ?.map((e) =>
            e == null ? null : Region.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'heroStations': instance.heroStations,
      'regions': instance.regions,
    };
