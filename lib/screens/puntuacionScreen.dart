import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Puntuacion extends StatelessWidget {
  const Puntuacion({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController nombreController = TextEditingController();
    TextEditingController puntuacionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registrar Puntuación",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Registrar Nueva Puntuación",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Por favor ingresa los datos requeridos para registrar una nueva puntuación.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          hintText: "ID (Clave primaria)",
                          prefixIcon: const Icon(Icons.fingerprint, color: Colors.white70),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nombreController,
                        decoration: InputDecoration(
                          hintText: "Nombre de la Película",
                          prefixIcon: const Icon(Icons.movie, color: Colors.white70),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: puntuacionController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Puntuación (1-10)",
                          prefixIcon: const Icon(Icons.star, color: Colors.white70),
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          String id = idController.text.trim();
                          String nombre = nombreController.text.trim();
                          String puntuacion = puntuacionController.text.trim();

                          if (id.isEmpty || nombre.isEmpty || puntuacion.isEmpty) {
                            _mostrarAlerta(context, "Falta campos", "Por favor completa todos los campos.");
                            return;
                          }

                          int puntuacionInt = int.tryParse(puntuacion) ?? 0;
                          if (puntuacionInt < 1 || puntuacionInt > 10) {
                            _mostrarAlerta(context, "Error de Puntuación", "No te puedes pasar de 10.");
                            return;
                          }

                          guardarPuntuacion(id, nombre, puntuacion);
                          idController.clear();
                          nombreController.clear();
                          puntuacionController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Guardar Puntuación",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> guardarPuntuacion(String id, String nombre, String puntuacion) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("peliculas/$id");

    await ref.set({
      "id": id,
      "nombre": nombre,
      "puntuacion": puntuacion,
    });
  }

  void _mostrarAlerta(BuildContext context, String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
