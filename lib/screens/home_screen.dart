import 'package:flutter/material.dart';

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
            // Implementa la lógica para cerrar la sesión
          }),
          _buildMenuItem(context, 'Contactar por WhatsApp', () {
            // Implementa la lógica para contactar por WhatsApp
          }),
          _buildMenuItem(context, 'Calendario y horario de apertura', () {
            // Implementa la lógica para ver el calendario y horario de apertura
          }),
          _buildMenuItem(context, 'Gestión de peluqueros', () {
            // Implementa la lógica para la gestión de peluqueros
          }),
          _buildMenuItem(context, 'Reservas', () {
            // Implementa la lógica para ver las reservas
          }),
          _buildMenuItem(context, 'Comprobación de horarios', () {
            // Implementa la lógica para comprobar los horarios
          }),
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
}
