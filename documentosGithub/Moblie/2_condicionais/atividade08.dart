void main() {
  var x = 11;
  var y = 20;
  var z = 19;

  if (x == y || x == z || z == y) {
    print('Está proibido o uso de variáveis com valores iguais!');
  } else if (x > y && x > z) {
    print('A variável x é a maior com valor $x');
  } else if (z > y && z > x) {
    print('A variável z é a maior com valor $z');
  } else if (y > x && y > z) {
    print('A variável y é a maior com valor $y');
  }
}
