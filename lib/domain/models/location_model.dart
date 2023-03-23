class LocationModel{
  double? latitude,longitude;
  String? source;

  LocationModel({this.latitude,this.longitude,this.source});

  Map<String, dynamic> toJson() {
    return{
      'latitude': latitude,
      'longitude': longitude,
      'source': source
    };
  }

  @override
  String toString() {
    return 'LocationModel{latitude: $latitude, longitude: $longitude, source: $source}';
  }

}