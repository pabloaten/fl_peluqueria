import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:fl_peluqueria/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:local_auth/local_auth.dart';

class InicioSesionScreen extends StatefulWidget {
  const InicioSesionScreen({Key? key}) : super(key: key);

  @override
  _InicioSesionScreenState createState() => _InicioSesionScreenState();
}

class _InicioSesionScreenState extends State<InicioSesionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  String email = '';
  String password = '';
  String errorMessage = '';

  Future<String?> _showResetPasswordDialog(BuildContext context) async {
    TextEditingController emailController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restablecer Contraseña'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Correo Electrónico'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(emailController.text);
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void _showResetEmailSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Correo electrónico enviado'),
          content:
              Text('Se ha enviado un enlace para restablecer tu contraseña.'),
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
  }

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
      setState(() {
        errorMessage = 'Error al iniciar sesión. Verifica tus credenciales.';
      });
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
        // Lógica para iniciar sesión si la autenticación biométrica es exitosa
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: AppTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  suffixIcon: Icon(Icons.email, color: AppTheme.primary),
                  labelStyle: TextStyle(
                    color: AppTheme.primary,
                  ),
                  fillColor: AppTheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                    color: AppTheme.primary,
                  ),
                  suffixIcon: Icon(Icons.lock, color: AppTheme.primary),
                  fillColor: AppTheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: signIn,
                child: const Text('Iniciar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String? resetEmail =
                      await _showResetPasswordDialog(context);
                  if (resetEmail != null && resetEmail.isNotEmpty) {
                    try {
                      await _auth.sendPasswordResetEmail(email: resetEmail);
                      _showResetEmailSentDialog(context);
                    } catch (e) {
                      print(
                          'Error al enviar el correo electrónico de restablecimiento: $e');
                    }
                  }
                },
                child: Text('¿Has olvidado tu contraseña?'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
              ),
              Container(
                width: 450,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: authenticateWithBiometrics,
                  child: const Text('Iniciar Sesión con Huella Digital'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegistrarScreen()),
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
      ),
    );
  }
}
