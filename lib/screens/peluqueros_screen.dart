import 'package:flutter/material.dart';
import 'package:fl_peluqueria/screens/screens.dart';

class PeluquerosScreen extends StatelessWidget {
   
  const PeluquerosScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
    title: Text('Example'),
    onSearch: (value) => setState(() => searchValue = value)
  ),
      body: Center(
         child: Text('PeluquerosScreen'),
      ),
    );
  }
}