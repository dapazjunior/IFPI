void main() {
  double preco = 10;
  double simples = 0.1;
  double master = 0.25;
  double ultra = 0.5;
  double totalDesconto = 0;
  double precoFinal = 0;

  // desconto simples 10% -- desconto master 25% -- desconto ultra 50%
  String categoria = 'u';

  switch (categoria) {
    case 'n':
      print('O valor do produto será R\$$preco.');
      break;
    case 's':
      totalDesconto = preco * simples;
      precoFinal = preco - totalDesconto;
      print(
          'O valor do desconto Simples será R\$$totalDesconto! O valor do produto será R\$$precoFinal.');
      break;
    case 'm':
      totalDesconto = preco * master;
      precoFinal = preco - totalDesconto;
      print(
          'O valor do desconto Master será R\$$totalDesconto! O valor do produto será R\$$precoFinal.');
      break;
    case 'u':
      totalDesconto = preco * ultra;
      precoFinal = preco - totalDesconto;
      print(
          'O valor do desconto Ultra será R\$$totalDesconto! O valor do produto será R\$$precoFinal.');
      break;
    default:
      print('Status não verificado!');
  }
}
