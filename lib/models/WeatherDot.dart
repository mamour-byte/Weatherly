class Location {
  final String city;
  final String country ;
  final String lat;
  final String long;

  Location({
    required this.city,
    required this.country,
    required this.lat,
    required this.long,
  });
}


class Forecast {
  final List<Daily> daily;


  Forecast({required this.daily});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> dailyData = List<Map<String, dynamic>>.from(json['daily']);

    List<Daily> dailyList = []; //

    dailyData.forEach((item) {
      var day = Daily.fromJson(item);
      dailyList.add(day);
    });

    return Forecast(
      daily: dailyList,
    );
  }
}



class Daily {
  final int dt;
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;
  final double pressure;
  final double humidity;
  final double wind;
  final String icon;

  Daily({ required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.low, required this.high,
    required this.description,
    required this.pressure,
    required this.humidity,
    required this.wind
    , required this.icon}) ;

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      dt: json['dt'].toInt(),
      temp: json['temp']['day'].toDouble(),
      feelsLike: json['feels_like']['day'].toDouble(),
      low: json['temp']['min'].toDouble(),
      high: json['temp']['max'].toDouble(),
      description: json['weather'][0]['description'],
      pressure: json['pressure'].toDouble(),
      humidity: json['humidity'].toDouble(),
      wind: json['wind_speed'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}


class Weather {
  final double temp;
  final String description;
  final double feelsLike;
  final double hight;
  final double low;
  final double pressure;
  final double humidity;
  final double wind;
  final String icon;

  Weather({
    required this.temp,
    required this.description,
    required this.feelsLike,
    required this.hight,
    required this.low,
    required this.pressure,
    required this.humidity,
    required this.wind,
    required this.icon,
  });

  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(
      temp: ((json['main']['temp'])-273.15).toDouble().truncate(),
      description: json['weather'][0]['description'],
      feelsLike: ((json['main']['feels_like'] )-273).toDouble().truncate(),
      hight: ((json['main']['temp_max'] )-273.15).toDouble().truncate(),
      low: ((json['main']['temp_min'] )-273.15).toDouble().truncate(),
      pressure: (json['main']['pressure']).toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      wind: json['wind']['speed'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }

}