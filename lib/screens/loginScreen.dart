import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba/navigators/drawer.dart';
import 'package:prueba/screens/registroScreen.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Iniciar Sesión",
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
                        "Bienvenido de nuevo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Inicia sesión para continuar disfrutando de nuestro contenido exclusivo.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: "Correo Electrónico",
                          prefixIcon: const Icon(Icons.email, color: Colors.white70),
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
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
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
                        onPressed: () =>
                            login(email.text, password.text, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          registro(context);
                        },
                        child: const Text(
                          "¿No tienes cuenta? Regístrate aquí",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
}

void registro(context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const registroScreen()));
}

Future<void> login(email, pass, context) async {
  if (email.isEmpty || pass.isEmpty) {
    mostrarAlerta(context, "Error", "Por favor, completa todos los campos.",
        Icons.error, Colors.red);
    return;
  }

  if (!email.contains('@')) {
    mostrarAlerta(context, "Error", "El correo electrónico debe contener '@'.",
        Icons.error, Colors.red);
    return;
  }

  if (pass.length < 6) {
    mostrarAlerta(context, "Error", "La contraseña debe tener al menos 6 caracteres.",
        Icons.error, Colors.red);
    return;
  }

  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MiDrawer()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      mostrarAlerta(
        context,
        "Error",
        "Usuario no encontrado.",
        Icons.error,
        Colors.red,
      );
    } else if (e.code == 'wrong-password') {
      mostrarAlerta(
        context,
        "Error",
        "Contraseña incorrecta.",
        Icons.error,
        Colors.red,
      );
    } else {
      mostrarAlerta(
        context,
        "Error",
        "Error de autenticación: ${e.message}",
        Icons.error,
        Colors.red,
      );
    }
  } catch (e) {
    mostrarAlerta(
      context,
      "Error",
      "Ha ocurrido un error. Inténtalo de nuevo.",
      Icons.error,
      Colors.red,
    );
  }
}

void mostrarAlerta(BuildContext context, String titulo, String mensaje,
    IconData icono, Color colorIcono) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(icono, color: colorIcono),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          mensaje,
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Cerrar",
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}