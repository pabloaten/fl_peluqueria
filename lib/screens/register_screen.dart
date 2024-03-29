import 'dart:convert';
import 'package:fl_peluqueria/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:fl_peluqueria/screens/login_screen.dart';

class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({Key? key}) : super(key: key);

  @override
  State<RegistrarScreen> createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  bool _sliderEnabledPrivacidad = false;
  bool _sliderEnabledPromociones = false;
  bool _sliderSexoHombre = true;
  bool _sliderSexoMujer = false;
  bool _obscureTextContrasena = true;
  bool _obscureTextConfirmar = true;
  final myFormKey = GlobalKey<FormState>();
  final String databaseURL =
      'https://fl-productos2023-2024-default-rtdb.europe-west1.firebasedatabase.app/';

  // Método para insertar datos en la base de datos
  Future<void> insertData(Map<String, dynamic> data) async {
    final Uri url = Uri.parse('$databaseURL/usuarios.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Datos insertados correctamente');
      } else {
        print('Error al insertar datos: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al insertar datos: $error');
    }
  }

  final Map<String, String> formValues = {
    'nombreApellidos': '',
    'sexo': '',
    'email': '',
    'telefono': '',
    'contraseña': '',
    'confirmar': '',
    'rol': 'peluquero'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REGISTRARSE"),
        elevation: 0,
        backgroundColor: AppTheme.primary,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InicioSesionScreen()),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: myFormKey,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 17,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 46, 46, 46),
                      offset: Offset(2, 2.5),
                      blurRadius: 6,
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      activeColor: const Color.fromARGB(255, 20, 40, 56),
                      value: _sliderSexoHombre,
                      title: const Text('Hombre'),
                      onChanged: (value) {
                        _sliderSexoHombre = value;
                        setState(() {
                          _sliderSexoMujer = false;
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      activeColor: const Color.fromARGB(255, 20, 40, 56),
                      value: _sliderSexoMujer,
                      title: const Text('Mujer'),
                      onChanged: (value) {
                        _sliderSexoMujer = value;
                        setState(() {
                          _sliderSexoHombre = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Nombre y Apellidos',
                   labelStyle: TextStyle(
                    color: AppTheme.primary, // Color del labelText
                  ),
                  suffixIcon: Icon(Icons.person,
                    color: AppTheme.primary,),
                ),
                onChanged: (value) => formValues['nombreApellidos'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre y apellidos';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 17,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  labelText: 'E-mail',
                   labelStyle: TextStyle(
                    color: AppTheme.primary, // Color del labelText
                  ),
                  suffixIcon: Icon(Icons.alternate_email_outlined,
                    color: AppTheme.primary,),
                ),
                onChanged: (value) => formValues['email'] = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'Introduce una dirección de correo válida';
                },
              ),
              const SizedBox(
                height: 17,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 8,
                obscureText: _obscureTextContrasena,
                decoration: InputDecoration(
                  hintText: '********',
                  labelText: 'Contraseña',
                   labelStyle: TextStyle(
                    color: AppTheme.primary, // Color del labelText
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextContrasena = !_obscureTextContrasena;
                      });
                    },
                    child: Icon(_obscureTextContrasena
                        ? Icons.visibility
                        : Icons.visibility_off,
                          color: AppTheme.primary,),
                  ),
                ),
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Minimo 8 caracteres';
                  } else {
                    formValues['contraseña'] = value;
                  }
                },
              ),
              const SizedBox(
                height: 17,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 8,
                obscureText: _obscureTextConfirmar,
                decoration: InputDecoration(
                  hintText: '********',
                  labelText: 'Confirmar contraseña',
                  labelStyle: TextStyle(
                    color: AppTheme.primary, // Color del labelText
                  ),
                  suffixIcon: GestureDetector(
                   
                    onTap: () {
                      setState(() {
                        _obscureTextConfirmar = !_obscureTextConfirmar;
                      });
                    },
                    child: Icon(_obscureTextConfirmar
                        ? Icons.visibility
                        : Icons.visibility_off,
                          color: AppTheme.primary,),
                        
                  ),
                ),
                validator: (value) {
                  if (value!.length < 8) {
                    return 'Minimo 8 caracteres';
                  } else if (formValues['contraseña'] != value) {
                    return "Las contraseñas tienen que coincidir";
                  } else {
                    formValues['confirmar'] = value;
                  }
                },
              ),
              const SizedBox(
                height: 17,
              ),
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Número de teléfono',
                  labelText: 'Teléfono',
                  suffixIcon: Icon(
                    Icons.phone,
                    color: AppTheme.primary, // Color del icono
                  ),
                  labelStyle: TextStyle(
                    color: AppTheme.primary, // Color del labelText
                  ),
                ),
                onChanged: (value) => formValues['telefono'] = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu número de teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              /*  SwitchListTile.adaptive(
                activeColor: const Color.fromARGB(255, 20, 40, 56),
                value: _sliderEnabledPromociones,
                title: const Text(
                  'Acepto las Promociones y aviso push/mail',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                onChanged: (value) {
                  _sliderEnabledPromociones = value;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 10,
              ), */
              SwitchListTile.adaptive(
                activeColor: const Color.fromARGB(255, 20, 40, 56),
                value: _sliderEnabledPrivacidad,
                title: const Text(
                  'Acepto las condiciones de uso y privacidad',
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                onChanged: (value) {
                  setState(() {
                    _sliderEnabledPrivacidad = value;
                  });
                },
              ),
              if (!_sliderEnabledPrivacidad)
                Text(
                  'Por favor, acepta las condiciones de uso y privacidad',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: const StadiumBorder(),
                ),
                onPressed: () async {
                  if (!_sliderEnabledPrivacidad) {
                    return;
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());

                    if (myFormKey.currentState!.validate()) {
                      if (_sliderSexoHombre) {
                        formValues['sexo'] = 'H';
                      } else if (_sliderSexoMujer) {
                        formValues['sexo'] = 'M';
                      } else if (!_sliderSexoHombre && !_sliderSexoMujer) {
                        formValues['sexo'] = 'H';
                      }
                      print(formValues);

                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: formValues['email']!,
                          password: formValues['contraseña']!,
                        );
                        await insertData({
                          'nombreApellidos': formValues['nombreApellidos'],
                          'sexo': formValues['sexo'],
                          'email': formValues['email'],
                          'telefono': formValues['telefono'],
                          'rol': formValues['rol'],
                          // Agrega más campos según sea necesario
                        });
                        // Redirigir al usuario a la pantalla de inicio de sesión
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InicioSesionScreen()),
                        );
                      } catch (e) {
                        print('Error al registrar usuario: $e');
                        // Manejar el error apropiadamente
                      }
                    } else {
                      print('Formulario no válido');
                      return;
                    }
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Crear una cuenta',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
