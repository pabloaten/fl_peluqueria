import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:fl_peluqueria/screens/register_screen.dart';
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
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300, // ajusta el alto según sea necesario
              width: 300, // ajusta el ancho según sea necesario
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit
                    .contain, // para ajustar la imagen dentro del contenedor
              ),
            ), // Agrega la imagen encima de los campos
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => email = value,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                prefixIcon: Icon(Icons.email),
                fillColor: AppTheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(0)), // Bordes completamente cuadrados
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => password = value,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock), // Icono a la izquierda del campo
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: signIn,
                child: const Text('Iniciar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: authenticateWithBiometrics,
              child: const Text('Iniciar Sesión con Huella Digital'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrarScreen()),
                );
              },
              child: const Text('Registrarse'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
