import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../Services/WeatherServices.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final String apiKey = "9606444e75b0bd62e4fb9ede031a9d64";
  List<Map<String, dynamic>> cityMarkers = [];

  final List<String> cities = ['Dakar', 'Thies', 'Kaolack', 'Saint-Louis'];

  @override
  void initState() {
    super.initState();
    loadCityWeather();
  }

  Future<void> loadCityWeather() async {
    List<Map<String, dynamic>> results = [];

    for (String city in cities) {
      try {
        final data = await getCityWeather(city);
        results.add(data);
      } catch (e) {
        debugPrint("Erreur pour $city: $e");
      }
    }

    setState(() {
      cityMarkers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(14.6928, -17.4467),
              initialZoom: 6,
              interactionOptions: InteractionOptions(
                // enablePanning: true,
                // enableZooming: true,
              ),
            ),
            children: [
              // 🎨 Basemap grise minimaliste
              TileLayer(
                urlTemplate:
                "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c'],
              ),

              // 🌦 Couches météo OpenWeather
              TileLayer(
                urlTemplate: getWeatherTileUrl(
                  layer: "temp_new",
                  apiKey: apiKey,
                ),
              ),

              // 📍 Marqueurs villes
              MarkerLayer(
                markers: cityMarkers.map((city) {
                  return Marker(
                    point: LatLng(city["lat"], city["lon"]),
                    width: 100,
                    height: 70,
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${city["name"]}: ${city["temp"].toInt()}°C",
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(Icons.location_pin, color: Colors.blueGrey, size: 28),
                      ],
                    ),
                  );

                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
