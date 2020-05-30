import 'package:flutter/material.dart';
import 'package:peliculas/lib/src/pages/pelicula_detalle.dart';
import 'lib/src/pages/home_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/'      : (BuildContext context) => HomePage(),
        'detalle': (BuildContext context) => PeliculaDetalle()
      },
    );
  }
}