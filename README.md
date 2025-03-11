# Minimal Weather App

A beautiful, minimal weather application built with Flutter that shows current weather conditions with a modern UI design.

## Features

- 🌡️ Real-time weather information
- 📍 Location-based weather data
- 🎨 Dynamic UI that changes based on time of day
- 💫 Beautiful animations for different weather conditions
- 🔄 Pull-to-refresh functionality
- 🌈 Modern, minimal design with glassmorphism effects

## Screenshots

[Add your app screenshots here]

## Getting Started

### Prerequisites

- Flutter SDK (3.6.1 or higher)
- Dart SDK (3.6.0 or higher)
- An OpenWeatherMap API key

### Installation

1. Clone the repository
```bash
git clone https://github.com/your-username/weather_app.git
```

2. Navigate to the project directory
```bash
cd weather_app
```

3. Install dependencies
```bash
flutter pub get
```

4. Update the API key in `lib/services/weather_service.dart`
```dart
final _weatherService = WeatherService('your_api_key_here');
```

5. Run the app
```bash
flutter run
```

## Dependencies

- `http`: ^1.3.0 - For making API calls
- `geolocator`: ^13.0.2 - For getting device location
- `geocoding`: ^3.0.0 - For converting coordinates to address
- `lottie`: ^3.3.1 - For weather animations
- `google_fonts`: ^6.1.0 - For custom fonts
- `intl`: ^0.19.0 - For date formatting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/)
- Weather animations from [LottieFiles](https://lottiefiles.com/)
- Inspired by modern weather app designs
