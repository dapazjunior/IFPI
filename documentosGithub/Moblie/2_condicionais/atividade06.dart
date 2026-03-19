void main() {
  String senha = '1234';
  String tentativa = '1234'; // altere para outro valor para ver "ACESSO NEGADO"

  if (senha == tentativa) {
    print('ACESSO PERMITIDO');
  } else {
    print('ACESSO NEGADO');
  }
}
