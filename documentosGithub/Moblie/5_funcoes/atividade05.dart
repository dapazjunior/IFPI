import 'dart:io';

void main() {
  print('Digite a temperatura:');
  double temp = double.parse(stdin.readLineSync()!);

  print('Digite o tipo de conversão (f = para Fahrenheit | c = para Celsius):');
  String tipo = stdin.readLineSync()!;

  switch (tipo) {
    case 'f':
      print('Em Fahrenheit ${temp} °C será:');
      print(celsiusParaFahrenheit(temp).toInt());
      break;
    case 'c':
      print('Em Celsius ${temp} °F será:');
      print(fahrenheitParaCelsius(temp).toStringAsFixed(2));
      break;
    default:
      print('Status não verificado');
  }
}

// Fórmula: (°C × 1,8) + 32 = °F
double celsiusParaFahrenheit(double celsius) {
  return (celsius * 1.8) + 32;
}

// Fórmula inversa: (°F - 32) / 1,8 = °C
double fahrenheitParaCelsius(double fahrenheit) {
  return (fahrenheit - 32) / 1.8;
}
