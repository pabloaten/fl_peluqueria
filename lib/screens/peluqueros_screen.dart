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
      body: Center(
         child: Text('PeluquerosScreen'),
      ),
    );
  }
  
  setState(String Function() param0) {}
}