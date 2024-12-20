import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../models/model_lat_lng.dart';
import '../models/model_place.dart';
import '../exception_handler/nominatim_exception.dart';

class NominatimRepository {
  final ApiService _apiService;

  NominatimRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService.instance;

  Future<List<Place>> search(String query) async {
    final response = await _apiService.get<List<dynamic>>(
      '/search',
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': 1,
      },
    );
    debugPrint("GET Response : ${response.data}");
    return response.data!.map((json) => Place.fromJson(json)).toList();
  }

  Future<Place> getAddressFromLatLng(LatLng coords) async {
    final response = await _apiService.get(
      '/reverse',
      queryParameters: {
        'lat': coords.latitude,
        'lon': coords.longitude,
        'format': 'json',
        'addressdetails': 1,
      },
    );

    return Place.fromJson(response.data);
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    final response = await _apiService.get<List<dynamic>>(
      '/search',
      queryParameters: {
        'q': address,
        'format': 'json',
        'limit': 1,
      },
    );

    if (response.data!.isEmpty) {
      throw NominatimException('Address not found');
    }

    final result = response.data![0];
    return LatLng(
      double.parse(result['lat']),
      double.parse(result['lon']),
    );
  }
}
