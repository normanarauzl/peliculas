import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/lib/src/models/pelicula_model.dart';


class CardSwiper extends StatelessWidget {

  final List<Pelicula> peliculas;


  CardSwiper({ @required this.peliculas });

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    return Container(
      child: Swiper(
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
          itemBuilder: (BuildContext context, int index){
            var peliculaId = '${ peliculas[index].id }-tarjeta';
            return Hero(
                tag: peliculaId,
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]);
                      },
                      child: FadeInImage(
                          image: NetworkImage(peliculas[index].getPosterImg()),
                          placeholder: AssetImage('assets/img/loading.gif'),
                          fit: BoxFit.cover,
                      ),
                ),
              ),
            );
          },
          itemCount: peliculas.length
        ),
    );
  }
}