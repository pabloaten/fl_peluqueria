import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:local_auth/local_auth.dart';

class InicioSesionScreen extends StatelessWidget {
  const InicioSesionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final LocalAuthentication _localAuth = LocalAuthentication();

    String email = '';
    String password = '';

    Future<void> signIn() async {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('Usuario autenticado: ${userCredential.user!.uid}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        print('Error al iniciar sesión: $e');
        // Manejar el error apropiadamente
      }
    }

    Future<void> authenticateWithBiometrics() async {
      try {
        bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Por favor, autentica para iniciar sesión',
        );
        if (authenticated) {
          // Autenticación biométrica exitosa
          print('Autenticación biométrica exitosa');
          // Lógica para iniciar sesión
          signIn();
        } else {
          // Autenticación biométrica fallida
          print('Autenticación biométrica fallida');
          // Puedes manejar este caso según tu lógica de la aplicación
        }
      } catch (e) {
        // Error al autenticar
        print('Error al autenticar: $e');
        // Puedes manejar el error apropiadamente
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => email = value,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => password = value,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: authenticateWithBiometrics,
              child: const Text('Iniciar Sesión con Huella Digital'),
            ),
          ],
        ),
      ),
    );
  }
}
