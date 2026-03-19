void main() {
  int number = 10;

  print('Número iniciado foi $number');

  if (number < 1) {
    print('fora do padrão');
  }

  print('Contagem Pares');
  if (number % 2 == 0) {
    for (int i = 2; i <= number; i += 2) {
      print(i);
    }
  }

  print('Contagem Impares');
  for (int i = 1; i <= number; i += 2) {
    print(i);
  }
}
