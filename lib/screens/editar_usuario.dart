import 'package:flutter/material.dart';
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:fl_peluqueria/services/usuarios_services.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;
  final UsuariosServices usuariosServices;

  const EditarUsuarioScreen({Key? key, required this.usuario, required this.usuariosServices}) : super(key: key);

  @override
  _EditarUsuarioScreenState createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _rolController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombreApellidos);
    _rolController = TextEditingController(text: widget.usuario.rol);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre y Apellidos'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _rolController,
              decoration: InputDecoration(labelText: 'Rol'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Actualizar los datos del usuario con los valores de los campos de texto
                widget.usuario.nombreApellidos = _nombreController.text;
                widget.usuario.rol = _rolController.text;
                
                // Llamar al método para actualizar el usuario
                final String? result = await widget.usuariosServices.updateUsuario(widget.usuario, widget.usuario.email);
                
                if (result != null) {
                  print('Usuario actualizado exitosamente');
                } else {
                  print('Error al actualizar el usuario');
                }
                
                // Volver a la pantalla anterior después de guardar los cambios
                Navigator.pop(context); 
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
