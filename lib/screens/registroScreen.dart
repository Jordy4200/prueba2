import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba/screens/loginScreen.dart';

class registroScreen extends StatelessWidget {
  const registroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confimPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Crear Cuenta",
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
                        "Unete a nuestra  APP de Peliculas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Crea tu cuenta ya!!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: emailController,
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
                        obscureText: true,
                        controller: passwordController,
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
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        controller: confimPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirmar Contraseña",
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
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
                        onPressed: () => registro(
                            emailController.text,
                            passwordController.text,
                            confimPasswordController.text,
                            context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Registrarse",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const loginScreen())); // Regresar al login
                        },
                        child: const Text(
                          "¿Ya tienes una cuenta? Inicia Sesión",
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

Future<void> registro(email, password, confirmPassword, context) async {
  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    error_alert(context, 'Por favor, completa todos los campos.');
    return;
  }

  if (password != confirmPassword) {
    mostrarAlerta(
      context,
      "Error",
      "Las contraseñas no coinciden. Verifica e intenta nuevamente.",
      Icons.error,
      Colors.red,
    );
    return;
  }

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuario registrado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'weak-password':
        error_alert(context,
            'La contraseña es demasiado débil. Intenta con una más segura.');
        break;
      case 'email-already-in-use':
        error_alert(context, 'El correo ya está en uso por otro usuario.');
        break;
      case 'invalid-email':
        error_alert(context,
            'El formato del correo no es válido. Verifica e intenta de nuevo.');
        break;
      case 'operation-not-allowed':
        error_alert(
            context, 'El registro con correo y contraseña no está habilitado.');
        break;
      default:
        error_alert(context, 'Ocurrió un error: ${e.message}');
        break;
    }
  } catch (e) {
    error_alert(context, 'Se produjo un error inesperado: ${e.toString()}');
  }
}

void error_alert(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8.0),
            Text("Error", style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(
          mensaje,
          style: const TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cerrar",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
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
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
