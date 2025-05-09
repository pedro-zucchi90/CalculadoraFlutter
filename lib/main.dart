import 'package:flutter/material.dart';

void main() {
  runApp(const Calculadora());
}

class Calculadora extends StatelessWidget {
  const Calculadora({super.key});

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
                  ElevatedButton(onPressed: () {}, child: const Text('7', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('8', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('9', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('/', style: TextStyle(fontSize: 30),)),

                  // Linha 2
                  ElevatedButton(onPressed: () {}, child: const Text('4', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('5', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('6', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('*', style: TextStyle(fontSize: 30),)),

                  // Linha 3
                  ElevatedButton(onPressed: () {}, child: const Text('1', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('2', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('3', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('-', style: TextStyle(fontSize: 30),)),

                  // Linha 4
                  ElevatedButton(onPressed: () {}, child: const Text('0', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('.', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('=', style: TextStyle(fontSize: 30),)),
                  ElevatedButton(onPressed: () {}, child: const Text('+', style: TextStyle(fontSize: 30),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}