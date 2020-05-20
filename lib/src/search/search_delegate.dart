import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  final peliculas = [
    'Aquaman',
    'Batman',
    'Iroman',
     'Spiderman',
    'Capitan America'
  ];

  final peliculasReciente = [
    'Spiderman',
    'Capitan America'
  ];

  String seleccion = '';
  final peliculasProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las accion de nuestro AppBar

    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = '';
      
      })
    ];
  }
 @override
  String get searchFieldLabel => 'Buscar pelicula';
  
  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation),
       onPressed: (){
         close(context, query);
       }
       );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultado que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: 
              peliculas.map((pelicula){
                return ListTile(
                  leading: FadeInImage(
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImg()),
                    fit: BoxFit.contain,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(pelicula.originalTitle),
                    onTap: (){
                      close(context, null);
                      pelicula.uniqueId = '';
                      Navigator.pushNamed(
                      context, 'detalle',
                      arguments: pelicula);
                    },
                );
              }).toList()
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
    // WHERE
    // Son las sugerencias cuando la persona escribe
    // final listaSugerida = ((query.isEmpty) 
    //                         ? peliculasReciente 
    //                         : peliculas.where((pel) =>
    //                             pel.toLowerCase().startsWith(query.toLowerCase())
    //                             )).toList();
    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, index){
    //     return ListTile(title: Text(listaSugerida[index]),
    //     leading: Icon(Icons.movie),
    //     onTap: (){
    //       query = listaSugerida[index];
    //         seleccion = listaSugerida[index];
    //         // showResults(context);
    //     },
    //     );
    //   },
    // );
  }

}