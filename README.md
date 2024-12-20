![](https://raw.githubusercontent.com/YudizAndroidPayal/flutter_nominatim/main/screenshots/banner.gif)

![GitHub code size](https://img.shields.io/github/languages/code-size/YudizAndroidPayal/flutter_nominatim)
[![Pub](https://img.shields.io/pub/v/flutter_nominatim.svg)](https://pub.dartlang.org/packages/flutter_nominatim)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![package publisher](https://img.shields.io/pub/publisher/flutter_nominatim.svg)](https://pub.dev/packages/flutter_nominatim/publisher)

# flutter_nominatim

 **Completely Free & Open Source!**
 Unlike other geocoding services, Nominatim is 100% free to use with **NO API key required**.
 You can start implementing location features in your app immediately without any payment or API key setup.

## Example Screenshots 📸

|                                                         Place Search                                                          |                                                  Convert LatLng to Address                                                  |                                                  Convert Address to LatLng                                                  |
|:-----------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------:|
| <img src="https://raw.githubusercontent.com/YudizAndroidPayal/flutter_nominatim/main/screenshots/ss_search.png" width="240"/> | <img src="https://raw.githubusercontent.com/YudizAndroidPayal/flutter_nominatim/main/screenshots/ss_geo1.png" width="240"/> | <img src="https://raw.githubusercontent.com/YudizAndroidPayal/flutter_nominatim/main/screenshots/ss_geo2.png" width="240"/> |
|                                          Auto-complete search with realtime results                                           |                                        Convert coordinates to human-readable address                                        |                                         Convert address to geographical coordinates                                         |

### Key Benefits

| Feature | Description | Benefit |
|---------|-------------|----------|
| 💰 Free Forever | No API key, no pricing tiers | Save hundreds of dollars compared to paid geocoding services |
| 🔑 No Authentication | No API keys or tokens needed | Quick implementation without setup hassle |
| 🌍 Global Coverage | Worldwide address database | Works everywhere your app does |
| 🚀 Easy Integration | Simple API methods | Get started in minutes |
| ⚡ Performance Optimized | Built-in rate limiting & caching | Smooth user experience |

## Features Overview

### 1. Place Search 🔍
- Auto-complete with debouncing
- Real-time results as you type
- Most relevant matches
- Rich place details
- Polygon Boundaries for places

### 2. Geocoding Services

| Service | Description | Example |
|---------|-------------|---------|
| Forward Geocoding | Convert address to coordinates | "London Bridge" → (51.5074, -0.1278) |
| Reverse Geocoding | Convert coordinates to address | (51.5074, -0.1278) → "London Bridge, London, UK" |

### 3. Built-in Optimizations
- Automatic request debouncing
- Rate limit handling
- Error management
- Input validation

## Quick Start

### Installation

```yaml
dependencies:
  flutter_nominatim: ^1.0.0
```

### Basic Usage

```dart
// Initialize
final nominatim = Nominatim.instance;

// Search places
final results = await nominatim.search("London");

// Get address from coordinates
final address = await nominatim.getAddressFromLatLng(51.5074, -0.1278);

// Get coordinates from address
final coordinates = await nominatim.getLatLngFromAddress("London Bridge");
```

## Implementation Examples

### Auto-complete Search Widget
```dart
TextField(
  controller: searchController,
  decoration: const InputDecoration(
    hintText: 'Search places...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (query) {
    if (query.length >= 3) {
      nominatim.search(query).then((results) {
        // Handle results
      });
    }
  },
)
```

## Usage Guidelines

### Input Constraints

| Parameter | Range/Format | Example |
|-----------|-------------|---------|
| Latitude | -90 to 90 | 51.5074 |
| Longitude | -180 to 180 | -0.1278 |
| Search Query | Min 3 characters | "London" |

### Rate Limiting
- Maximum 1 request per second
- Built-in request management
- Automatic request queuing

## Why It's Free & Open

Nominatim is powered by OpenStreetMap, the world's largest collaborative mapping project. This means:
- 🆓 **Completely Free**: No hidden costs or subscription fees
- 🔓 **No API Key Required**: Start developing immediately
- 🌐 **Community Driven**: Regular updates from global contributors
- 📈 **Constantly Improving**: Database grows and improves daily

[//]: # (## Documentation & Resources)

[//]: # ()
[//]: # (| Resource | Description | Link |)

[//]: # (|----------|-------------|------|)

[//]: # (| API Docs | Official Nominatim API documentation | [Link]&#40;https://nominatim.org/release-docs/latest/api/Overview/&#41; |)

[//]: # (| Example Code | Implementation examples | [Link]&#40;example/&#41; |)

[//]: # (| Usage Policy | Official usage guidelines | [Link]&#40;https://operations.osmfoundation.org/policies/nominatim/&#41; |)

## Attribution Requirements
When using this plugin, include:
```
© OpenStreetMap contributors
```

## Support & Contribution

We welcome:
- 🐛 Bug reports
- 💡 Feature suggestions
- 🤝 Pull requests
- 📖 Documentation improvements

## License
MIT License - feel free to use in your projects!

## Visitors Count
<img align="left" src="https://profile-counter.glitch.me/flutter_nominatim/count.svg" alt="Loading">
