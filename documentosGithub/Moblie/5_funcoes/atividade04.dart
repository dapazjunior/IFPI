void main() {
  int primeiro = 1, segundo = 5, terceiro = 3;
  maior(primeiro, segundo, terceiro);
}

void maior(int x, int y, int z) {
  if (x == y || x == z || z == y) {
    print('Esta proibido uso de valores iguais');
  } else if (x > y && x > z) {
    print('A variavel x é a de maior valor com $x ');
  } else if (y > x && y > z) {
    print('A variavel y é a de maior valor com $y ');
  } else if (z > x && z > y) {
    print('A variavel z é a de maior valor com $z ');
  }
}
