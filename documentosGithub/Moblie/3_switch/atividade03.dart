void main() {
  double preco = 10;
  double desconto = 0.1;
  double total_Desconto = preco * desconto;
  double preco_final = preco - total_Desconto;

  String categoria = 'd';

  switch (categoria) {
    case 'n':
      print('O valor do produto será R\$$preco.');
      break;
    case 'd':
      print(
        'O valor do desconto será R\$$total_Desconto! O valor do produto será R\$$preco_final.');
      break;
    default:
      print('Status não verificado');
  }
}
