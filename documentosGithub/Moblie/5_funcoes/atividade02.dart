void main() {
  int primeiro = 11, segundo = 20, terceiro = 3;

  Menor(primeiro, segundo, terceiro);
}

int Menor(int valor1, int valor2, int valor3) {
  if ((valor1 <= valor2) && (valor1 <= valor3)) {
    print('O menor valor é o numero: $valor1');
  } else {
    if ((valor2 <= valor1) && (valor2 <= valor3)) {
      print('O menor valor é o numero: $valor2');
    } else {
      print('O menor valor é o numero: $valor3');
    }
  }
  return 0;
}
