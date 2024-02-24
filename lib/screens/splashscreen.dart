import 'package:fl_peluqueria/screens/home_screen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 130,
            ),
            Image(
              image: AssetImage("assets/logo.png"),
            ),
            SizedBox(
              height: 100,
            ),
            Image(
              image: AssetImage("assets/loading.gif"),
              height: 80,
              width: 80,
            )
          ],
        )),
      ),
    );
  }
}
