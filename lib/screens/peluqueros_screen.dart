import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_peluqueria/screens/screens.dart';
import 'package:fl_peluqueria/models/usuario.dart';
import 'package:fl_peluqueria/services/usuarios_services.dart';
import 'package:provider/provider.dart';
import 'package:fl_peluqueria/widgets/card_peluquero.dart';
class PeluquerosScreen extends StatelessWidget {
   
  const PeluquerosScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final usuariosServices = Provider.of<UsuariosServices>(context);
    String searchValue='';
    final List<String> _suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];
    return Scaffold(
      appBar: EasySearchBar(
    title: Text('Gestión peluqueros'),
    onSearch: (value) => setState(() => searchValue = value),
    suggestions: _suggestions
  ),
      body: ListView.builder(
        itemCount: usuariosServices.usuarios.length,
        itemBuilder: ( BuildContext context, index) => GestureDetector(
          onTap: () {
            usuariosServices.usuarioSeleccionado = usuariosServices.usuarios[index].copy();
            Navigator.pushNamed(context, 'usuario');
          },
          child: PeluqueroCard(
            usuario:usuariosServices.usuarios[index],
          )
        )
      ),
    );
  }
  
  setState(String Function() param0) {}
}