import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// Função principal que inicia a aplicação
void main() {
  runApp(const Calculadora());
}

// Classe que define o estado da calculadora
class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  _CalculadoraState createState() => _CalculadoraState();
}

// Classe que gerencia o estado da calculadora
class _CalculadoraState extends State<Calculadora> {
  String _display = ''; // Variável que armazena o que está sendo exibido na tela

  // Função que atualiza o display com um novo valor
  void _updateDisplay(String value) {
    setState(() {
      _display += value;
    });
  }

  // Função que mostra o resultado da expressão matemática
  void _showResult() {
    try {
      final result = eval(_display); // Chama a função eval para calcular o resultado
      setState(() {
        _display = result.toString(); // Atualiza o display com o resultado
      });
    } catch (e) { // Se houver um erro ao calcular o resultado exibe um alerta
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

  // Função que avalia uma expressão matemática e retorna o resultado
  double eval(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/'); // Substitui os símbolos de multiplicação e divisão
    Parser p = Parser(); // Cria um parser para analisar a expressão
    Expression exp = p.parse(expression); // Analisa a expressão e cria uma expressão matemática
    final cm = ContextModel(); // Cria um modelo de contexto para a avaliação caso tenha incógnitas
    return exp.evaluate(EvaluationType.REAL, cm); // Avalia a expressão e retorna o resultado
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              child: GridView(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
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