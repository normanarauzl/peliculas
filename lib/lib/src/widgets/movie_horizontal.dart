import 'package:flutter/material.dart';
import 'package:peliculas/lib/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {
    
    final _screenSize = MediaQuery.of(context).size;
    
    _pageController.addListener(() { 
      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200)
        siguientePagina();
    });


    return Container(
      height: _screenSize.height * 0.1,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (context, index) => _tarjeta(context, peliculas[index])
      ),
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    var peliculaId = '${ pelicula.id }-poster';
    final tarjeta = 
      Container(
          margin: EdgeInsets.only(right: 15.0),
          child: Column(
            children: <Widget>[
              Hero(
                  tag: peliculaId,
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    image: NetworkImage(pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/loading.gif'),
                    fit: BoxFit.cover,
                    height: 150.0,
                  ),
                ),
              ),
              SizedBox( height: 1.0),
              Text(
                pelicula.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              )
            ],
          ),
        );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        },
      );
  }

  // List<Widget> _tarjetas(BuildContext context){
  //   return peliculas.map((p){
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(20.0),
  //             child: FadeInImage(
  //               image: NetworkImage(p.getPosterImg()),
  //               placeholder: AssetImage('assets/img/loading.gif'),
  //               fit: BoxFit.cover,
  //               height: 150.0,
  //             ),
  //           ),
  //           SizedBox( height: 1.0),
  //           Text(
  //             p.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );
    
  //   }).toList();
  
  // }

}