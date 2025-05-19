import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'splash_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

final ThemeData meuTemaClaro = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF1E1E1E),
    iconTheme: IconThemeData(color: Color(0xFF1E1E1E)),
    titleTextStyle: TextStyle(
      color: Color(0xFF1E1E1E),
      fontSize: 20,
      fontFamily: 'Hollow',
      fontWeight: FontWeight.normal,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE0E0E0),
      foregroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Hollow',
        fontSize: 20,
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF1E1E1E)),
  ),
);

final ThemeData meuTemaEscuro = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0A0C0F),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1F26),
    foregroundColor: Color(0xFFE0E0E0),
    iconTheme: IconThemeData(color: Color(0xFFE0E0E0)),
    titleTextStyle: TextStyle(
      color: Color(0xFFE0E0E0),
      fontSize: 20,
      fontFamily: 'Hollow',
      fontWeight: FontWeight.normal,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3A3C4E),
      foregroundColor: const Color(0xFFE0E0E0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Hollow',
        fontSize: 20,
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
  ),
);

void main() {
  runApp(MyRootApp());
}

class MyRootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: meuTemaClaro,
          darkTheme: meuTemaEscuro,
          themeMode: mode,
          home: const SplashScreenWidget(),
        );
      },
    );
  }
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
        // Limita para no máximo 6 casas decimais e remove zeros desnecessários
        _resultado = result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
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

    // Converte porcentagem: ex 50% -> 50/100
    expression = expression.replaceAllMapped(
      RegExp(r'(\d+(\.\d+)?)%'),
      (match) => '(${match.group(1)}/100)'
    );

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
    final theme = Theme.of(context);
    final escuro = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text('Hollow Calculator'),
        leading: Image.asset(escuro ? 'assets/images/hollow-icon-dark.png' : 'assets/images/hollow-icon-light.png'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, mode, __) => IconButton(
              icon: Icon(
                mode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round,
                color: theme.appBarTheme.iconTheme?.color,
              ),
              onPressed: () {
                themeNotifier.value =
                    themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: escuro ? const Color(0xFF111319) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true, // rola automaticamente para baixo
                    child: Text(
                      _display,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 35,
                        color: escuro ? const Color(0xFFAAAAAA) : const Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _resultado,
                    key: ValueKey<String>(_resultado),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 50,
                      color: escuro ? const Color(0xFFD0D0D0) : const Color(0xFF222222),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GridView.count(
                padding: const EdgeInsets.all(10.0),
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  buildButton('C', limpar: true, escuro: escuro),
                  buildButton('%', operador: true, escuro: escuro),
                  buildButton('√', operador: true, escuro: escuro),
                  buildButton('÷', operador: true, escuro: escuro),

                  buildButton('7', escuro: escuro),
                  buildButton('8', escuro: escuro),
                  buildButton('9', escuro: escuro),
                  buildButton('×', operador: true, escuro: escuro),

                  buildButton('4', escuro: escuro),
                  buildButton('5', escuro: escuro),
                  buildButton('6', escuro: escuro),
                  buildButton('-', operador: true, escuro: escuro),

                  buildButton('1', escuro: escuro),
                  buildButton('2', escuro: escuro),
                  buildButton('3', escuro: escuro),
                  buildButton('+', operador: true, escuro: escuro),

                  buildButton('()', parenteses: true, escuro: escuro),
                  buildButton('0', escuro: escuro),     
                  buildButton('.', operador: true, escuro: escuro),
                  buildButton('=', igual: true, escuro: escuro), 
                  
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text,
      {bool operador = false, bool limpar = false, bool igual = false, bool parenteses = false, required bool escuro}) {
    Color backgroundColor;
    Color textColor;

    if (limpar || operador || parenteses) {
      backgroundColor = escuro ? const Color(0xFF3A3C4E) : const Color.fromARGB(255, 216, 215, 194);
      textColor = escuro ? const Color(0xFFE0E0E0) : const Color(0xFF1E1E1E);
    } else if (igual) {
      backgroundColor = escuro ? const Color(0xFFB1316A) : const Color.fromARGB(255, 199, 188, 113);
      textColor = escuro ? const Color(0xFFE0E0E0) : Colors.white;
    } else {
      backgroundColor = escuro ? const Color(0xFF1E1F26) : const Color.fromARGB(255, 201, 203, 212);
      textColor = escuro ? const Color(0xFFE0E0E0) : const Color(0xFF1E1E1E);
    }

    return ElevatedButton(
      onPressed: () async {
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
          color: textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Hollow',
        ),
      ),
    );
  }
}
