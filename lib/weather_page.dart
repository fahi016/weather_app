import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin {
  final _weatherService = WeatherService('ae0f1131aa99c5f138ee00baabda3820');
  Weather? _weather;
  late AnimationController _controller;
  bool _isLoading = true;

  // Get the appropriate Lottie animation based on weather condition
  String _getWeatherAnimation(String? condition) {
    if (condition == null) return 'https://assets5.lottiefiles.com/packages/lf20_KUFdS6.json';
    
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'https://assets3.lottiefiles.com/packages/lf20_KUFdS6.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'https://assets3.lottiefiles.com/packages/lf20_h9qp9c.json';
      case 'thunderstorm':
        return 'https://assets3.lottiefiles.com/packages/lf20_hsg5t3.json';
      case 'clear':
        return 'https://assets3.lottiefiles.com/packages/lf20_jqfghjk.json';
      case 'snow':
        return 'https://assets3.lottiefiles.com/packages/lf20_khzniaya.json';
      default:
        return 'https://assets3.lottiefiles.com/packages/lf20_jqfghjk.json';
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  List<Color> _getBackgroundGradient() {
    var hour = DateTime.now().hour;
    if (hour < 6) { // Night
      return [
        const Color(0xFF172133),
        const Color(0xFF2B4073),
      ];
    } else if (hour < 12) { // Morning
      return [
        const Color(0xFF2E3B85),
        const Color(0xFF7898FB),
      ];
    } else if (hour < 17) { // Afternoon
      return [
        const Color(0xFF0B8793),
        const Color(0xFF360033),
      ];
    } else if (hour < 20) { // Evening
      return [
        const Color(0xFF23074D),
        const Color(0xFFCC5333),
      ];
    } else { // Night
      return [
        const Color(0xFF172133),
        const Color(0xFF2B4073),
      ];
    }
  }

  // fetch weather
  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true);
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching weather: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fetchWeather();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _getBackgroundGradient(),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_p8bfn5to.json',
                    width: 200,
                    height: 200,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchWeather,
                  backgroundColor: Colors.white,
                  color: Colors.blue.shade700,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 20),
                      // Greeting and Location
                      Text(
                        _getGreeting(),
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _weather?.cityName ?? "Loading city...",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      // Weather animation
                      Container(
                        height: 220,
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Lottie.network(
                          _getWeatherAnimation(_weather?.mainCondition),
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..repeat();
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Temperature and condition card
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_weather?.temperature.round()}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '°C',
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _weather?.mainCondition?.toUpperCase() ?? "LOADING...",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Date and Time
                      Center(
                        child: Text(
                          DateFormat('EEEE, d MMMM').format(DateTime.now()),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}