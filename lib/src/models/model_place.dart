class Place {
  final String placeId;
  final String displayName;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> addressDetails;

  Place({
    required this.placeId,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    required this.addressDetails,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'].toString(),
      displayName: json['display_name'],
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
      addressDetails: json['address'] ?? {},
    );
  }

  Map<String, dynamic> toJson() => {
        'place_id': placeId,
        'display_name': displayName,
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'address': addressDetails,
      };
}
