import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:vibration/vibration.dart';
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

  double eval(String expression) {
    expression = expression.replaceAll('×', '*').replaceAll('÷', '/'); // Substitui símbolos de multiplicação e divisão por seus equivalentes matemáticos
    
    expression = expression.replaceAllMapped(
      RegExp(r'(\d+(\.\d+)?)%'),
      (match) => '(${match.group(1)}/100)'
    ); // Substitui porcentagem por divisão por 100 para calcular o valor percentual

    expression = expression.replaceAllMapped(
      RegExp(r'√(\d+(\.\d+)?|[^]+)'),
      (match) => 'sqrt(${match.group(1)})'
    ); // Substitui raiz quadrada por sua função matemática correspondente

    Parser p = Parser(); // Cria um novo parser para analisar a expressão
    Expression exp = p.parse(expression); // Analisa a expressão e retorna uma instância de Expression
    ContextModel cm = ContextModel(); // Neste caso, não é necessário criar um novo modelo de contexto para a avaliação, pois o contexto não é utilizado na avaliação da expressão. No entanto, é obrigatório passar um contexto para o método evaluate, então um contexto vazio é criado para atender a essa exigência.
    return exp.evaluate(EvaluationType.REAL, cm); // Avalia a expressão matemática e retorna o resultado
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(mensagem), // Mostra a mensagem de erro específica
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void vibrar() async {
    if (await Vibration.hasVibrator() ?? false) {  // Verifica se o dispositivo tem um vibrador e, se sim, faz o dispositivo vibrar por 50 milissegundos
      Vibration.vibrate(duration: 50); 
    }
  }

  void _updateDisplay(String value) {
    setState(() {
      _display += value; // Concatena o novo valor à string de display
    });
  }

  void _showResult() {
    try {
      final result = eval(_display); // Calcula o resultado da expressão matemática
      setState(() {
        _resultado = result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), ''); // Atualiza o resultado com o valor calculado, formatado para ter no máximo 6 casas decimais e sem zeros à direita. 
        //O RegExp '\.?0+$' é usado para remover os zeros à direita e o ponto decimal se não houver mais casas decimais.
      });
    } catch (e) {
      _mostrarErro('Erro ao calcular o resultado'); // Mostra um erro se a expressão não puder ser avaliada
    }
  }

  void converterDecimalParaBinario() {
  try {
    int valorDecimal = int.parse(_resultado.isNotEmpty ? _resultado : _display); // Converte o resultado ou display para um número decimal
    setState(() {
        _resultado = valorDecimal.toRadixString(2); // Atualiza o resultado com o valor binário correspondente
      });
    } catch (e) {
      _mostrarErro('Digite um número decimal válido para converter.'); // Mostra um erro se o número não for decimal válido
    }
  }

  void converterBinarioParaDecimal() {
    try {
      int valorDecimal = int.parse(_resultado.isNotEmpty ? _resultado : _display, radix: 2); // Converte o resultado ou display para decimal a partir do binário
      setState(() {
        _resultado = valorDecimal.toString(); // Atualiza o resultado com o valor decimal correspondente
      });
    } catch (e) {
      _mostrarErro('Digite um número binário válido para converter.'); // Mostra um erro se o número não for binário válido
    }
  }

  void _apagarUltimoCaractere() {
    setState(() {
      if (_display.isNotEmpty) {
        _display = _display.substring(0, _display.length - 1); // Remove o último caractere da string de display
      }
    });
  }

  Widget buildButton(
    String text, {
    bool operador = false,
    bool limpar = false,
    bool igual = false,
    bool parenteses = false,
    bool binario = false,
    bool decimal = false,
    bool apagar = false,
    required bool escuro,
  }) {
    Color backgroundColor;
    Color textColor;

    if (operador || parenteses || binario || decimal) {
      backgroundColor = escuro
          ? const Color(0xFF3A3C4E)
          : const Color.fromARGB(255, 216, 215, 194);
      textColor = escuro
          ? const Color(0xFFE0E0E0)
          : const Color(0xFF1E1E1E);
    } else if (igual || apagar || limpar) {
      backgroundColor = escuro
          ? const Color(0xFFB1316A)
          : const Color(0xFFC28D27);
      textColor = escuro
          ? const Color(0xFFE0E0E0)
          : Colors.white;
    } else {
      backgroundColor = escuro
          ? const Color(0xFF1E1F26)
          : const Color.fromARGB(255, 201, 203, 212);
      textColor = escuro
          ? const Color(0xFFE0E0E0)
          : const Color(0xFF1E1E1E);
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(12),
      ),
      onPressed: () async {
        vibrar();
        setState(() {
          if (limpar) {
            _display = '';
            _resultado = '';
          } else if (igual) {
            _showResult();
          } else if (binario) {
            converterDecimalParaBinario();
          } else if (decimal) {
            converterBinarioParaDecimal();
          } else if (parenteses) {
            final aberto = '('.allMatches(_display).length;
            final fechado = ')'.allMatches(_display).length;
            _display += (aberto > fechado) ? ')' : '(';
          } else if (apagar) {
            _apagarUltimoCaractere();
          } else {
            _updateDisplay(text);
          }
        });
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: (igual || operador || limpar || parenteses || apagar) ? 35 : 20,
          color: textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Hollow',
        ),
      ),
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: escuro ? const Color(0xFF303030) : const Color(0xFFE0E0E0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // DISPLAY
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
                const SizedBox(height: 10),
                // RESULTADO
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _resultado,
                        key: ValueKey<String>(_resultado),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 45,
                          color: escuro ? const Color(0xFFD0D0D0) : const Color(0xFF222222),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  buildButton('BIN', binario: true, escuro: escuro),
                  buildButton('DEC', decimal: true, escuro: escuro),
                  buildButton('√', operador: true, escuro: escuro),
                  buildButton('^', operador: true, escuro: escuro),
                  
                  buildButton('C', limpar: true, escuro: escuro),
                  buildButton('%', operador: true, escuro: escuro),
                  buildButton('+', operador: true, escuro: escuro),
                  buildButton('-', operador: true, escuro: escuro),

                  buildButton('7', escuro: escuro),
                  buildButton('8', escuro: escuro),
                  buildButton('9', escuro: escuro),
                  buildButton('×', operador: true, escuro: escuro),

                  buildButton('4', escuro: escuro),
                  buildButton('5', escuro: escuro),
                  buildButton('6', escuro: escuro),
                  buildButton('÷', operador: true, escuro: escuro),

                  buildButton('1', escuro: escuro),
                  buildButton('2', escuro: escuro),
                  buildButton('3', escuro: escuro),
                  buildButton('⌫', apagar: true, escuro: escuro),

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
}
