import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 95),
            const Image(
              width: double.infinity,
              height: 380,
              image: AssetImage("assets/logo2.png"),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 20, 40, 56),
                  shape: const StadiumBorder(),
                  elevation: 0),
              onPressed: () {
                /* final route = MaterialPageRoute(
                    builder: (context) => const RegistrarScreen());
                Navigator.pushReplacement(context, route); */
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 93, right: 93, top: 13, bottom: 13),
                child: Text(
                  'Registrarme',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  elevation: 0,
                  shape: const StadiumBorder(),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 20, 40, 56), width: 2)),
              onPressed: () {
              /*   final route = MaterialPageRoute(
                    builder: (context) => const InicioSesionScreen());
                Navigator.push(context, route); */
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 88, right: 88, top: 13, bottom: 13),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
