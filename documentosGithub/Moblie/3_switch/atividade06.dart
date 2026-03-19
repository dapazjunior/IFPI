void main() {
  double a, b, c;
  a = 2;
  b = 2;
  c = 0;

  var operacao = 3;

  switch (operacao) {
    case 1:
      c = (a + b);
      print('$c');
      break;
    case 2:
      c = (a - b);
      print('$c');
      break;
    case 3:
      c = (a * b);
      print('$c');
      break;
    case 4:
      c = (a / b);
      print('$c');
      break;
    default:
      print('sem uso');
  }
}
