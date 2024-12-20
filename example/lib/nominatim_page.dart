import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nominatim/flutter_nominatim.dart';

/// A demo page showcasing Nominatim plugin functionalities including:
/// - Place search with autocomplete
/// - Conversion between coordinates and addresses
/// - Address to coordinates conversion
class NominatimPage extends StatefulWidget {
  const NominatimPage({super.key});

  @override
  State<NominatimPage> createState() => _NominatimPageState();
}

class _NominatimPageState extends State<NominatimPage> with SingleTickerProviderStateMixin {
  // Nominatim instance for API calls
  late Nominatim nominatim;

  // Tab controller for managing the three main features
  late TabController _tabController;

  // Debouncer for search optimization
  Timer? _apiCallDebouncer;

  // States for place search functionality
  final List<Place> _searchResults = [];
  final _searchController = TextEditingController();
  bool _isSearchLoading = false;

  // States for coordinates to address conversion
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  String _convertedAddress = '';
  bool _isLatLngLoading = false;

  // States for address to coordinates conversion
  final _addressController = TextEditingController();
  LatLng? _convertedLatLng;
  bool _isAddressLoading = false;

  @override
  void initState() {
    super.initState();
    nominatim = Nominatim.instance;
    _tabController = TabController(length: 3, vsync: this);
    _setupSearchListener();
  }

  /// Sets up a listener for the search input field
  /// Implements debouncing to prevent excessive API calls
  /// Only searches when input is 3 or more characters
  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_searchController.text.length >= 3) {
        // Cancel previous timer if it exists
        _apiCallDebouncer?.cancel();
        // Start new timer
        _apiCallDebouncer = Timer(const Duration(seconds: 1), () {
          _performSearch(_searchController.text);
        });
      } else {
        setState(() => _searchResults.clear());
      }
    });
  }

  /// Performs search using Nominatim API
  /// Shows up to 5 results
  /// Handles loading states and errors
  Future<void> _performSearch(String query) async {
    setState(() => _isSearchLoading = true);
    try {
      final results = await nominatim.search(query);
      setState(() {
        _searchResults.clear();
        _searchResults.addAll(results.take(5));
        _isSearchLoading = false;
      });
    } catch (e) {
      setState(() => _isSearchLoading = false);
      _showError('Search failed: ${e.toString()}');
    }
  }

  /// Converts given latitude and longitude to address
  /// Validates input before making API call
  /// Updates UI with result or error message
  Future<void> _convertLatLngToAddress() async {
    if (!_validateLatLng()) return;

    setState(() => _isLatLngLoading = true);
    try {
      final lat = double.parse(_latController.text);
      final lng = double.parse(_lngController.text);
      final place = await nominatim.getAddressFromLatLng(lat, lng);
      setState(() {
        _convertedAddress = place.displayName;
        _isLatLngLoading = false;
      });
    } catch (e) {
      setState(() => _isLatLngLoading = false);
      _showError('Conversion failed: ${e.toString()}');
    }
  }

  /// Converts address to latitude and longitude coordinates
  /// Validates input before making API call
  /// Updates UI with result or error message
  Future<void> _convertAddressToLatLng() async {
    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter an address');
      return;
    }

    setState(() => _isAddressLoading = true);
    try {
      final coordinates = await nominatim.getLatLngFromAddress(_addressController.text);
      setState(() {
        _convertedLatLng = coordinates;
        _isAddressLoading = false;
      });
    } catch (e) {
      setState(() => _isAddressLoading = false);
      _showError('Conversion failed: ${e.toString()}');
    }
  }

  /// Validates latitude and longitude input
  /// Checks for:
  /// - Valid number format
  /// - Latitude range (-90 to 90)
  /// - Longitude range (-180 to 180)
  bool _validateLatLng() {
    try {
      final lat = double.parse(_latController.text);
      final lng = double.parse(_lngController.text);
      if (lat < -90 || lat > 90) {
        _showError('Latitude must be between -90 and 90');
        return false;
      }
      if (lng < -180 || lng > 180) {
        _showError('Longitude must be between -180 and 180');
        return false;
      }
      return true;
    } catch (e) {
      _showError('Please enter valid numbers for latitude and longitude');
      return false;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _addressController.dispose();
    _apiCallDebouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC200),
        title: const Text("Flutter Nominatim Demo"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          tabs: const [
            Tab(text: "Search"),
            Tab(text: "LatLng to Address"),
            Tab(text: "Address to LatLng"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSearchTab(),
          _buildLatLngToAddressTab(),
          _buildAddressToLatLngTab(),
        ],
      ),
    );
  }

  /// Builds the search tab with autocomplete functionality
  /// Includes:
  /// - Search input field with debounce
  /// - Loading indicator
  /// - Results list showing up to 5 matches
  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search places...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearchLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final place = _searchResults[index];
                  return ListTile(
                    title: Text(place.displayName),
                    subtitle: Text(
                      'Lat: ${place.latitude}, Lng: ${place.longitude}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the coordinates to address conversion tab
  /// Features:
  /// - Separate input fields for latitude and longitude
  /// - Input validation
  /// - Conversion button with loading state
  /// - Result display
  Widget _buildLatLngToAddressTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _latController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    hintText: 'Enter latitude (-90 to 90)',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _lngController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    hintText: 'Enter longitude (-180 to 180)',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLatLngLoading ? null : _convertLatLngToAddress,
            child: _isLatLngLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Convert to Address'),
          ),
          if (_convertedAddress.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_convertedAddress),
          ],
        ],
      ),
    );
  }

  /// Builds the address to coordinates conversion tab
  /// Features:
  /// - Multi-line address input
  /// - Conversion button with loading state
  /// - Coordinates result display
  Widget _buildAddressToLatLngTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Enter address to convert',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isAddressLoading ? null : _convertAddressToLatLng,
            child: _isAddressLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Convert to LatLng'),
          ),
          if (_convertedLatLng != null) ...[
            const SizedBox(height: 16),
            const Text('Coordinates:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Latitude: ${_convertedLatLng!.latitude}\nLongitude: ${_convertedLatLng!.longitude}',
            ),
          ],
        ],
      ),
    );
  }
}
