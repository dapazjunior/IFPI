import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingControllerGasolina =
  TextEditingController();
  final TextEditingController _textEditingControllerAlcool =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gasolina x Alcool'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Gasolina x Alcool'
              ),
            ),
            Image.network('https://cdn-icons-png.flaticon.com/256/2933/2933939.png',
            height: 170),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Valor da gasolina'),
              ),
              controller: _textEditingControllerGasolina,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                label: Text('Valor do alcool'),
              ),
              controller: _textEditingControllerAlcool,
            ),
            ElevatedButton(
              onPressed: () {
              print('Valor da gasolina: ' + _textEditingControllerGasolina.text);
              print('Valor do Alcool: ' + _textEditingControllerAlcool.text);
            }, 
            child: Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }
}
