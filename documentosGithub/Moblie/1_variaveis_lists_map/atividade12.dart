void main() {
  List frutas = ['maçã', 'uva', 'banana'];
  List valor = [1.010, 2.702, 3.001];

  int posicao = 1;

  Map caixa = {frutas[posicao]: valor[posicao].toStringAsFixed(2)};
  print(caixa);
}
