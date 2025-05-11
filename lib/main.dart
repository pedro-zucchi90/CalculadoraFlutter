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
    Parser p = Parser();
    Expression exp = p.parse(expression);
    final cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[800],
          title: const Text(
            'Calculadora do Heitor Scalco',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: const Icon(Icons.calculate, color: Colors.white, size: 30),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),

              child: Text(
                _display,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),

            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  //Linha 1
                  construirBotao('7'),
                  construirBotao('8'),
                  construirBotao('9'),
                  construirBotao('÷', operador: true),

                  //Linha 2
                  construirBotao('4'),
                  construirBotao('5'),
                  construirBotao('6'),
                  construirBotao('×', operador: true),

                  //Linha 3
                  construirBotao('1'),
                  construirBotao('2'),
                  construirBotao('3'),
                  construirBotao('-', operador: true),

                  //Linha 4
                  construirBotao('=', igual: true),
                  construirBotao('0'),
                  construirBotao('.', operador: true),
                  construirBotao('+', operador: true),

                  //Linha 5
                  construirBotao('C', limpar: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirBotao(String text, {bool operador = false, bool limpar = false, bool igual = false}) {
    
    Color backgroundColor;

    if (limpar) {
      backgroundColor = Colors.red[800]!;
    } else if (igual) {
      backgroundColor = Colors.green[700]!;
    } else if (operador) {
      backgroundColor = Colors.deepPurple;
    } else {
      backgroundColor = Colors.grey[850]!;
    }

    return ElevatedButton(
      onPressed: () {
        if (limpar) {
          setState(() => _display = '');
        } else if (igual) {
          _showResult();
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
          fontSize: text == '=' || operador || limpar ? 40 : 28,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}