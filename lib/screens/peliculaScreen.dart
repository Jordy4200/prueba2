import 'package:flutter/material.dart';
import 'dart:convert';

class Peliculas extends StatelessWidget {
  const Peliculas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas'),
      ),
      body: localListView(context),
    );
  }
}

Future<List> jsonLocal(context) async {
  final jsonString = await DefaultAssetBundle.of(context).loadString("assets/data/peliculas2.json");
  
  final Map<String, dynamic> jsonMap = json.decode(jsonString);

  return jsonMap['peliculas'];
}

Widget localListView(context) {
  return FutureBuilder(
    future: jsonLocal(context),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final datos = snapshot.data!;
        return ListView.builder(
          itemCount: datos.length,
          itemBuilder: (context, index) {
            final item = datos[index];
            return ListTile(
              title: Text(item['titulo']),
              subtitle: Text('Año: ${item['anio']}'),
              leading: Image.network(item['enlaces']['image'], height: 100,),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(item['titulo']),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: [
                            Text('Descripción: ${item['descripcion']}'),
                            SizedBox(height: 10),
                            Text('Duración: ${item['detalles']['duracion']}'),
                            Text('Director: ${item['detalles']['director']}'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      } else {
        return Center(child: Text("NO HAY DATA"));
      }
    },
  );
}
