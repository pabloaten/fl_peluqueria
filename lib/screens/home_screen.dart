import 'package:fl_peluqueria/provider/user_role_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:fl_peluqueria/screens/calendariosyhorarios_screen.dart';
import 'package:fl_peluqueria/screens/peluqueros_screen.dart';
import 'package:fl_peluqueria/screens/reservas_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  final List<Widget> _screens = [
    HomeContent(),
    PeluquerosScreen(),
    CalendarioYHorarioScreen(),
    ReservasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
        
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: AppTheme.primary,
        automaticallyImplyLeading: false,
      ),
      endDrawer: _buildDrawer(context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.black, // Color de los iconos seleccionados
        unselectedItemColor:
            Colors.black, // Establecer el color de fondo a negro
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Peluqueros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Reservas',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

/*   void _goToPeluquerosScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PeluquerosScreen()),
    );
  } */

  void _goToReservasScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservasScreen()),
    );
  }

  void _goToCalendariosScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarioYHorarioScreen()),
    );
  }

  void whatsapp() async {
    var contact = "+34695701397";
    var androidUrl = "whatsapp://send?phone=$contact&text=Peluqueria Pelopo";
    var iosUrl =
        "https://wa.me/$contact?text=${Uri.parse('Hi, I need some help')}";
    await launch(androidUrl);
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

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Center(
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User Role:',
            ),
            Consumer<UsuarioRoleProvider>(
              builder: (context, userRoleProvider, child) {
                return Text(
                userRoleProvider.user?.rol ?? 'Hola', // Muestra el rol del usuario
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
    );
  }
}