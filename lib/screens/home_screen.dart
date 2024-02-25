import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:fl_peluqueria/screens/calendariosyhorarios_screen.dart';
import 'package:fl_peluqueria/screens/peluqueros_screen.dart';
import 'package:fl_peluqueria/screens/reservas_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        // Impedir que la pantalla se pueda retroceder
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inicio'),
          backgroundColor: AppTheme.primary,
          automaticallyImplyLeading: false,
        ),
        endDrawer: _buildDrawer(context),
        body: Center(
          child: Text(user?.email ?? 'Usuario desconocido'),
        ),
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
              color: AppTheme.primary,
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
          _buildMenuItem(context, 'Ver peluqueros', () {
           _goToPeluquerosScreen(context);
          }),
          _buildMenuItem(context, 'Comprobación de horarios', () {
           _goToCalendariosScreen(context);
          }),
           _buildMenuItem(context, 'Ver Reservas', () {
           _goToReservasScreen(context);
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
void _goToPeluquerosScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PeluquerosScreen()),
  );
}
void _goToReservasScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>ReservasScreen()),
  );
}
void _goToCalendariosScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CalendarioYHorarioScreen()),
  );
}

  // Función para abrir WhatsApp
  void whatsapp() async {
    var contact = "+880123232333";
    var androidUrl = "whatsapp://send?phone=$contact&text=Hi, I need some help";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {}
  }

  // Función para cerrar sesión
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InicioSesionScreen(),
        ),
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
