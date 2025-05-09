import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: SplashScreenWidget(),
    debugShowCheckedModeBanner: false,
  ));
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _display = '';

  void _updateDisplay(String value) {
    setState(() {
      _display += value;
    });
  }

  void _showResult() {
    try {
      final result = eval(_display);
      setState(() {
        _display = result.toString();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Erro ao calcular o resultado'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  double eval(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');
    Parser p = Parser();
    Expression exp = p.parse(expression);
    final cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black, // fundo preto
        appBar: AppBar(
          backgroundColor: Colors.black, // appbar preta
          title: const Text(
            'Calculadora do Pedro e da Nicolle',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: const Icon(Icons.calculate, color: Colors.white, size: 30),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _display,
                style: const TextStyle(fontSize: 30, color: Colors.white), // texto branco
              ),
            ),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                children: [
                  // Botões
                  buildButton('7'),
                  buildButton('8'),
                  buildButton('9'),
                  buildButton('÷', operator: true),
                  buildButton('4'),
                  buildButton('5'),
                  buildButton('6'),
                  buildButton('×', operator: true),
                  buildButton('1'),
                  buildButton('2'),
                  buildButton('3'),
                  buildButton('-', operator: true),
                  ElevatedButton(
                    onPressed: _showResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[850],
                    ),
                    child: const Text('=', style: TextStyle(fontSize: 60, color: Colors.white)),
                  ),
                  buildButton('0'),
                  buildButton('.', operator: true),
                  buildButton('+', operator: true),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _display = '';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                    ),
                    child: const Text('C', style: TextStyle(fontSize: 30, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text, {bool operator = false}) {
    return ElevatedButton(
      onPressed: () => _updateDisplay(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: operator ? Colors.grey[800] : Colors.grey[900],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: text == '÷' || text == '×' || text == '-' || text == '+' || text == '=' || text == '.' ? 60 : 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
