import 'package:fl_peluqueria/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: const Text('Contenido de la página de inicio'),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildMenuItem(context, 'Cerrar sesión', () {
            _signOut(context);
          }),
          _buildMenuItem(context, 'Contactar por WhatsApp', () {
            whatsapp();
          }),
          // Otros elementos del menú...
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, Function() onTap) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

  // Función para abrir WhatsApp
  void whatsapp() async {
    var contact = "+880123232333";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      
    }
  }

  // Función para cerrar sesión

  // Dentro de la función _signOut en HomeScreen
void _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
         Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InicioSesionScreen()),
                        );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al cerrar sesión: $e'),
      ),
    );
  }
}

}
