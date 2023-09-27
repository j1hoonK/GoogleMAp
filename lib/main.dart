import 'package:flutter/material.dart';
import 'package:google_map/viewmodel/current_position.dart';
import 'package:provider/provider.dart';

import 'config/loading.dart';
import 'google_map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentPosition(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Map',
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white, foregroundColor: Colors.black)),
        home: GoogleMapApp(),
      ),
    );
  }
}
