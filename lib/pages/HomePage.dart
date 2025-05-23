import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Services/WeatherServices.dart';
import '../models/WeatherDot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Weather> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = getCurrentWeather("Dakar");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(color: Colors.white);
            } else if (snapshot.hasError) {
              return Text(
                'Erreur : ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasData) {
              final weather = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  children: [
                    const HeaderWidget(),
                    const SizedBox(height: 30),
                    TemperatureWidget(weather: weather),
                    const SizedBox(height: 30),
                    WeatherInfoCard(weather: weather),
                  ],
                ),
              );
            } else {
              return const Text(
                'Aucune donnée',
                style: TextStyle(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Colors.white, size: 22),
        SizedBox(width: 5),
        Text(
          'Dakar',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        )
      ],
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  final Weather weather;

  const TemperatureWidget({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getWeatherIcon(weather.icon),
        const SizedBox(height: 10),
        Text(
          weather.description,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          "${weather.temp.toInt()}°",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Ressenti ${weather.feelsLike.toInt()}°",
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ],
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final Weather weather;

  const WeatherInfoCard({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWeatherInfoItem(
            iconAsset: 'assets/icons/wind.svg',
            label: 'Vent',
            value: "${weather.wind} km/h",
          ),
          _buildWeatherInfoItem(
            iconAsset: 'assets/icons/humidity.svg',
            label: 'Humidité',
            value: "${weather.humidity.toInt()}%",
          ),
          _buildWeatherInfoItem(
            iconAsset: 'assets/icons/pressure.svg',
            label: 'Pression',
            value: "${weather.pressure} hPa",
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem({
    required String iconAsset,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        SvgPicture.asset(iconAsset, height: 30, color: Colors.white),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
