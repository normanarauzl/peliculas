import 'package:flutter/material.dart';
import 'package:peliculas/lib/src/models/pelicula_model.dart';
import 'package:peliculas/lib/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{
  
  final peliculasProvider = new PeliculasProvider();
  String _seleccion = '';
  final peliculas = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam!',
    'Ironman',
    'Capitan America',
    'Superman',
    'Ironman 2',
    'Ironman 3',
    'Ironman 4',
    'Ironman 5',
    'IronMandingo'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appBar
    
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(_seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Crea las sugerencias de busqueda
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if (snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
              children: peliculas.map( (pelicula) {
                  return ListTile(
                    leading: FadeInImage(
                      image: NetworkImage( pelicula.getPosterImg() ),
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      width: 50.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text( pelicula.title ),
                    subtitle: Text( pelicula.originalTitle ),
                    onTap: (){
                      close( context, null);
                      // pelicula.uniqueId = '';
                      Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                    },
                  );
              }).toList()
            );
        } else return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    
  }


  // final listaSugerida = (query.isEmpty) ? 
    //                       peliculasRecientes : 
    //                       peliculas.where((element) => element.toLowerCase().startsWith(query.toLowerCase())
    //                     ).toList();


    // return ListView.builder(
    //         itemCount: listaSugerida.length,
    //         itemBuilder: (context, index){
    //           return ListTile(
    //             leading: Icon(Icons.movie),
    //             title: Text(listaSugerida[index]),
    //             onTap: (){
    //               _seleccion = listaSugerida[index];
    //               showResults(context);
    //             },
    //           );
    //         }
    //   );

}