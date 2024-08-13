import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: FutureBuilder<Weather>(
          future: futureWeather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              Weather weather = snapshot.data!;

              return Column(
                children: [
                  const SizedBox(height: 20),
                  const HeaderWidget(),
                  const SizedBox(height: 30),
                  TemperatureWidget(weather: weather),
                  const SizedBox(height: 30),
                  WeatherInfoCard(weather: weather),
                ],
              );
            } else {
              return const Text('No data available');
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
        Icon(Icons.location_on , color: Colors.black,size: 20,),
        Text('Dakar',style: TextStyle(color:Colors.black , fontWeight: FontWeight.bold,fontSize: 20),)
      ],
    );
  }
}


class TemperatureWidget extends StatelessWidget {
  final Weather weather;

  const TemperatureWidget({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getWeatherIcon(weather.icon),
        Text(
          weather.description,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${weather.temp.toInt()}°",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Feels like ${weather.feelsLike.toInt()}°",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class WeatherInfoCard extends StatelessWidget {
  final Weather weather;

  const WeatherInfoCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary ,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildWeatherInfoItem(
            imageUrl: 'https://cdn-icons-png.flaticon.com/128/2011/2011448.png',
            label: "Wind",
            value: "${weather.wind} km/h",
          ),
          _buildWeatherInfoItem(
            imageUrl: 'https://cdn-icons-png.flaticon.com/128/5664/5664979.png',
            label: "Humidity",
            value: "${weather.humidity.toInt()}%",
          ),
          _buildWeatherInfoItem(
            imageUrl: 'https://cdn-icons-png.flaticon.com/128/4745/4745257.png',
            label: "Pressure",
            value: "${weather.pressure} hPa",
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoItem({
    required String imageUrl,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Image.network(
            imageUrl,
            cacheHeight: 25,
            cacheWidth: 25,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
