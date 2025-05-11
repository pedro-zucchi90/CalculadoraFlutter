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
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text('Calculadora do Pedro e da Nicolle', style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          leading: const Icon(Icons.calculate, color: Colors.white, size: 30,),
          ),
        
        body: Column(
          children: [
            // Display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_display, style: TextStyle(fontSize: 30)),
            ),

            // Botões
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  // Linha 1
                  ElevatedButton(onPressed: () => _updateDisplay('7'), child: const Text('7', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('8'), child: const Text('8', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('9'), child: const Text('9', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('÷'), child: const Text('÷', style: TextStyle(fontSize: 60),)),

                  // Linha 2
                  ElevatedButton(onPressed: () => _updateDisplay('4'), child: const Text('4', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('5'), child: const Text('5', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('6'), child: const Text('6', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('×'), child: const Text('×', style: TextStyle(fontSize: 60),)),

                  // Linha 3
                  ElevatedButton(onPressed: () => _updateDisplay('1'), child: const Text('1', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('2'), child: const Text('2', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('3'), child: const Text('3', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('-'), child: const Text('-', style: TextStyle(fontSize: 60),)),

                  // Linha 4
                  ElevatedButton(onPressed: () => _showResult(), child: const Text('=', style: TextStyle(fontSize: 60),)),
                  ElevatedButton(onPressed: () => _updateDisplay('0'), child: const Text('0', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () => _updateDisplay('.'), child: const Text('.', style: TextStyle(fontSize: 60),)),
                  ElevatedButton(onPressed: () => _updateDisplay('+'), child: const Text('+', style: TextStyle(fontSize: 60),)),

                  // Limpar resultado ou display
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _display = '';
                      });
                    },
                    child: const Text('C', style: TextStyle(fontSize: 30),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}