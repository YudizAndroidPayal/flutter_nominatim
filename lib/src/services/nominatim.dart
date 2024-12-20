import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nominatim/src/repo/nominatin_repo.dart';

import '../models/model_lat_lng.dart';
import '../models/model_place.dart';
import 'api_service.dart';

/// A singleton class that provides geocoding and place search functionality using Nominatim service.
/// This class handles search operations, coordinates conversions, and includes built-in optimizations
/// like debouncing for search queries.
class Nominatim {
  /// Repository instance to handle all API calls and data operations
  final NominatimRepository _repository;

  /// Stream controller for handling search queries
  final _searchController = StreamController<String>.broadcast();

  /// Timer for implementing debounce functionality on search queries
  Timer? _debounceTimer;

  /// Private constructor to ensure singleton pattern
  /// [repository] Optional repository instance for dependency injection
  Nominatim._({NominatimRepository? repository})
      : _repository = repository ?? NominatimRepository() {
    _setupSearchListener();
  }

  /// Singleton instance of the Nominatim class
  static final Nominatim instance = _initialize();

  /// Initializes the Nominatim instance and sets up required services
  /// Returns a new instance of Nominatim with initialized API service
  static Nominatim _initialize() {
    ApiService.instance.initialize();
    return Nominatim._();
  }

  /// Sets up the search stream listener
  /// Processes search queries that are at least 3 characters long
  /// Handles errors during search operations
  void _setupSearchListener() {
    _searchController.stream
        .where((query) => query.length >= 3)
        .listen((query) async {
      try {
        await search(query);
      } catch (e) {
        debugPrint('Search error: $e');
      }
    });
  }

  /// Performs a place search using the provided query
  /// [query] The search string to look up places
  /// Returns a Future containing a list of matching places
  Future<List<Place>> search(String query) => _repository.search(query);

  /// Converts geographical coordinates to an address (reverse geocoding)
  /// [lat] Latitude value
  /// [lng] Longitude value
  /// Returns a Future containing the place details for the given coordinates
  Future<Place> getAddressFromLatLng(double lat, double lng) =>
      _repository.getAddressFromLatLng(LatLng(lat, lng));

  /// Converts an address string to geographical coordinates (forward geocoding)
  /// [address] The address string to convert
  /// Returns a Future containing the coordinates for the given address
  Future<LatLng> getLatLngFromAddress(String address) =>
      _repository.getLatLngFromAddress(address);

  /// Handles search query changes with debouncing
  /// Implements a 1-second delay before processing the search query
  /// [query] The search query string
  void onSearchQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _searchController.add(query);
    });
  }

  /// Cleans up resources when the instance is no longer needed
  /// Closes the search controller and cancels any pending debounce timer
  void dispose() {
    _searchController.close();
    _debounceTimer?.cancel();
  }
}
