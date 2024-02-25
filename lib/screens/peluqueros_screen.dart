import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_peluqueria/screens/screens.dart';

class PeluquerosScreen extends StatelessWidget {
   
  const PeluquerosScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    String searchValue='';
    final List<String> _suggestions = ['Afeganistan', 'Albania', 'Algeria', 'Australia', 'Brazil', 'German', 'Madagascar', 'Mozambique', 'Portugal', 'Zambia'];
    return Scaffold(
      appBar: EasySearchBar(
    title: Text('Gestión peluqueros'),
    onSearch: (value) => setState(() => searchValue = value),
    suggestions: _suggestions
  ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/fondoInicioSesion.png'))),
          height: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: peluquerosServices.peluqueros.length,
            itemBuilder: (context, index) {
              Peluquero peluquero = peluquerosServices.peluqueros[index];
              return CustomWidgetPeluquero(
                nombre: peluquero.nombre,
                descripcion: peluquero.descripcion,
                imagen: NetworkImage(peluquero.imagen),
                usuario: usuario,
                peluqueria: peluqueria,
                peluquero: peluquero,
              );
            },
          )
        ),
    );
  }
  
  setState(String Function() param0) {}
}