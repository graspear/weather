import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/services/weather_service.dart';


class ForecastScreen extends StatefulWidget{
  final String city;
  final bool isCelsius;
  const ForecastScreen({
    Key? key,
    required this.city,
    required this.isCelsius,
  }) : super(key: key);
  @override
  State<ForecastScreen> createState()=>_ForecastScreen();
}

class _ForecastScreen extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  List<dynamic>? _forecast = [];

  @override
  void initState(){
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast()async{
    try{
      final forecastData = await _weatherService.fetch7DaysForecast(widget.city);
      setState((){
        _forecast = forecastData['forecast']['forecastday'];
      });
    }catch(e){
      print(e);
    }
  }
  double _convertTemperature(double tempCelsius) {
    if (widget.isCelsius) {
      return tempCelsius;
    } else {
      return (tempCelsius * 9 / 5) + 32;
    }
  }
  String _temperatureUnit() {
    return widget.isCelsius ? '°C' : '°F';
  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child:Scaffold(
        body: _forecast == null ?
        Container(
          decoration:BoxDecoration(
            gradient:LinearGradient(
              begin:Alignment.topCenter,
              end:Alignment.bottomCenter,
              colors:[
                Color(0xFF1A2344),
                Color.fromARGB(255,125,32,142),
                Colors.purple,
                Color.fromARGB(255,151,44,170),
              ],
            )
          ),
          child:Center(
            child:CircularProgressIndicator(
              color:Colors.white,
            ),
          ),
        )
        : Container(
          height:MediaQuery.of(context).size.height,
          decoration:BoxDecoration(
            gradient:LinearGradient(
              begin:Alignment.topCenter,
              end:Alignment.bottomCenter,
              colors:[
                Color(0xFF1A2344),
                Color.fromARGB(255,125,32,142),
                Colors.purple,
                Color.fromARGB(255,151,44,170),
              ],
            )
          ),
          child:SingleChildScrollView(
            child:Column(
              children:[
                Padding(padding:EdgeInsets.all(10),
                child:Row(
                  children:[
                    InkWell(onTap:(){
                      Navigator.pop(context);
                    },
                    child:Icon(
                      Icons.arrow_back,
                      color:Colors.white,
                      size:30
                    ),
                    ),
                    SizedBox(width:15),
                    Text(
                      "7 Day Forecast",
                      style:GoogleFonts.lato(
                        fontSize:30,
                        color:Colors.white,
                        fontWeight:FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ),
                ListView.builder(
                  physics:NeverScrollableScrollPhysics(),
                  shrinkWrap:true,
                  itemCount:_forecast!.length,
                  itemBuilder:(context,index){
                    final day = _forecast![index];
                    String iconUrl = 'http:${day['day']['condition']['icon']}';
                    return Padding(padding:EdgeInsets.all(10),
                    child:ClipRRect(
                      child:BackdropFilter(
                        filter:ImageFilter.blur(sigmaX:3,sigmaY:3),
                        child:Container(
                          padding:EdgeInsets.all(5),
                          width:110,
                          height:110,
                          decoration:BoxDecoration(
                            borderRadius:BorderRadius.circular(10),
                            gradient:LinearGradient(
                              begin:AlignmentDirectional.topStart,
                              end:AlignmentDirectional.bottomEnd,
                              colors:[
                                Color(0xFF1A2344).withOpacity(0.5),
                                Color(0xFF1A2344).withOpacity(0.2),
                              ],
                            )
                          ),
                          child:ListTile(
                            leading:Image.network(iconUrl),
                            title: Text(
                              '${day['date']}',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Avg: ${_convertTemperature(day['day']['avgtemp_c']).round()}${_temperatureUnit()}\n${day['day']['condition']['text']}',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        )
                      )
                    ),);
                  }

                )
              ]
            )
          )
        ),
      ),
    );
  }
}


