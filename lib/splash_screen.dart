import 'package:flutter/material.dart';
import 'main.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Calculadora()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0C0F), // Fundo principal
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/hollow-soul-icon.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Hollow Calculator',
              style: TextStyle(
                color: Color(0xFFE0E0E0), // Texto dos botões
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Hollow'
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFFE0E0E0), // Texto dos botões
            ),
          ],
        ),
      ),
    );
  }
} 