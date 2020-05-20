import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swipe_widget.dart';
import 'package:peliculas/src/widgets/moview_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Pelicula en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(context: context,
               delegate: DataSearch(),
               query: '',
              
               );
            },
            )
        ],
      ),
      body:
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
             Expanded(child: SizedBox(),),
            _swiperTarjetas(),
            Expanded(child: SizedBox(),),
            _footer(context)
          ]
        )
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
        return CardSwiper( peliculas: snapshot.data);
        } else {
          return Container(
            // height: 400.0,
            child:
           Center(
             child:
            CircularProgressIndicator())
            );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: 
              Theme.of(context).textTheme.subhead,),
          ),
            SizedBox(height: 5.0,),
            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
               if (snapshot.hasData) {
                 return MovieHorizontal(
                   peliculas: snapshot.data,
                   siguientePagina: peliculasProvider.getPopulares,
                   );
               }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
      ),
    );
  }
}