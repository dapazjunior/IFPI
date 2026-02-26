void main() {
  List frutas = ['banana', 'maçã', 'laranja', 'manga', 'uva'];
  List precos = [6, 10.5, 3.5, 6, 11];

  int posicao;
  posicao = 3;

  
  var produto = frutas[posicao];
  var valor = precos[posicao];

  print('O preço da $produto é $valor');
}