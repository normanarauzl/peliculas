import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:peliculas/lib/src/models/actores_model.dart';


import 'package:peliculas/lib/src/models/pelicula_model.dart';


class PeliculasProvider {

  String _apikey    = '95cdfc11e1b1031eabd4d725d1c4fc88';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();
  List<Actor> _actores = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Actor>> _procesarInfoCast(String token) async {
    
    final url = Uri.https(_url, '3/movie/$token', {
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    
    return cast.actores;
  }

  Future<List<Pelicula>> _procesarInfoPeliculas(String token, [String page]) async {
    
    final url = Uri.http(_url, '3/movie/$token', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : page
    });

    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    

    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    return await _procesarInfoPeliculas('now_playing');
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
    
    _cargando = true;
    _popularesPage++;

    final resp = await _procesarInfoPeliculas('popular', _popularesPage.toString());
    _populares.addAll(resp);

    popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> getUltimas() async {
    return await _procesarInfoPeliculas('latest');
  }

  Future <List<Actor>> getCast(String peliId) async{
    final resp = await _procesarInfoCast('$peliId/credits');

    _actores.addAll(resp);

    return _actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    

    final url = Uri.http(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'     : query
    });
    
    return _procesarRespuesta(url);
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    
    final resp = await http.get( url );
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    

    return peliculas.items;
  }

}