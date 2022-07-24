import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../provider/weather_provider.dart';
import '../widgets/weather_info.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/main_weather.dart';
import '../widgets/next_three_days.dart';
import '../widgets/request_error.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_detail.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _getData() async {
    _isLoading = true;
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);
    weatherData.getWeatherData();
    _isLoading = false;
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<WeatherProvider>(context, listen: false).getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = Provider.of<WeatherProvider>(context);
    final myContext = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: myContext.primaryColor,
                ),
              )
            : weatherData.loading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: myContext.primaryColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: mediaQuery.size.height * 1.3,
                      ),
                      child: Column(
                        children: [
                          SearchBar(wData: weatherData),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: 2,
                            effect: ExpandingDotsEffect(
                              activeDotColor: myContext.primaryColor,
                              dotHeight: 6,
                              dotWidth: 6,
                            ),
                          ),
                          weatherData.isRequestError
                              ? const RequestError()
                              : Expanded(
                                  child: PageView(
                                    controller: _pageController,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: mediaQuery.size.width,
                                        child: RefreshIndicator(
                                          onRefresh: () =>
                                              _refreshData(context),
                                          backgroundColor: Colors.blue,
                                          child: ListView(
                                            children: [
                                              MainWeather(wData: weatherData),
                                              WeatherInfo(
                                                  wData: weatherData
                                                      .currentWeather),
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  if (constraints.maxWidth >
                                                      800) {
                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: HourlyForecast(
                                                              weatherData
                                                                  .hourlyWeather),
                                                        ),
                                                        Expanded(
                                                          child: NextThreeDays(
                                                              weatherData
                                                                  .lastThreeDays),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Column(
                                                      children: [
                                                        HourlyForecast(
                                                            weatherData
                                                                .hourlyWeather),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        NextThreeDays(
                                                            weatherData
                                                                .lastThreeDays),
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: mediaQuery.size.height,
                                        width: mediaQuery.size.width,
                                        child: ListView(
                                          children: [
                                            WeatherDetail(wData: weatherData),
                                          ],
                                        ),
                                      ),
                                    ],
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
