
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:fl_peluqueria/services/usuarios_services.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombreApellidos);
    _emailController = TextEditingController(text: widget.usuario.email);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre y Apellidos'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes guardar los cambios del usuario
                // Por ejemplo, puedes llamar a un método en tu servicio de usuarios para actualizar los datos
                // usuariosServices.actualizarUsuario(widget.usuario.id, _nombreController.text, _emailController.text);
                Navigator.pop(context); // Volver a la pantalla anterior después de guardar los cambios
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}