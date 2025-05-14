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
  String _resultado = '';

  void _updateDisplay(String value) {
    setState(() {
      _display += value;
    });
  }

  void _showResult() {
    try {
      final result = eval(_display);
      setState(() {
        _resultado = result.toString();
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Erro ao calcular o resultado'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  double eval(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

    // Substitui √número ou √(expressão) por sqrt(...)
    expression = expression.replaceAllMapped(
      RegExp(r'√(\d+(\.\d+)?|\([^\)]+\))'),
      (match) => 'sqrt(${match.group(1)})'
    );

    Parser p = Parser();
    Expression exp = p.parse(expression);
    final cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0A0C0F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1F26),
          title: const Text(
            'Hollow Calculator',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 20,
              fontFamily: 'Hollow',
            ),
          ),
          leading: Image.asset('assets/images/hollow-icon.png'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // Display da calculadora
              width: double.infinity,
              height: 200,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111319),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _display,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 35,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _resultado,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 50,
                      color: Color(0xFFD0D0D0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Botões da calculadora
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GridView.count(
                  padding: const EdgeInsets.all(10.0),
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    buildButton('C', limpar: true),
                    buildButton('%', operador: true),
                    buildButton('√', operador: true),
                    buildButton('÷', operador: true),

                    buildButton('7'),
                    buildButton('8'),
                    buildButton('9'),
                    buildButton('×', operador: true),

                    buildButton('4'),
                    buildButton('5'),
                    buildButton('6'),
                    buildButton('-', operador: true),

                    buildButton('1'),
                    buildButton('2'),
                    buildButton('3'),
                    buildButton('+', operador: true),

                    buildButton('0'),
                    buildButton('.', operador: true),
                    buildButton('=', igual: true),
                    buildButton('()', parenteses: true),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text,
      {bool operador = false, bool limpar = false, bool igual = false, bool parenteses = false}) {
    Color backgroundColor;

    if (limpar || operador || parenteses) {
      backgroundColor = const Color(0xFF3A3C4E);
    } else if (igual) {
      backgroundColor = const Color(0xFFB1316A);
    } else {
      backgroundColor = const Color(0xFF1E1F26);
    }

    return ElevatedButton(
      onPressed: () {
        if (limpar) {
          setState(() {
            _display = '';
            _resultado = '';
          });
        } else if (igual) {
          _showResult();
        } else if (parenteses) {
          final aberto = '('.allMatches(_display).length;
          final fechado = ')'.allMatches(_display).length;
          setState(() {
            _display += (aberto > fechado) ? ')' : '(';
          });
        } else if (text == '√') {
          setState(() {
            _display += '√';
          });
        } else {
          _updateDisplay(text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: text == '=' || operador || limpar || parenteses ? 40 : 20,
          color: const Color(0xFFE0E0E0),
          fontWeight: FontWeight.bold,
          fontFamily: 'Hollow',
        ),
      ),
    );
  }
}
