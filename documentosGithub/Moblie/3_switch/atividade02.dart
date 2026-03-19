void main() {
  var idade = 18;
  var valor = 3;

  if (idade > 17) {
    valor = 1;
  } else {
    valor = 2;
  }

  String status = '$valor';

  switch (status) {
    case '1':
      print('Pode ter cartão de crédito');
      break;
    case '2':
      print('Não pode ter cartão de crédito');
      break;
    default:
      print('Status não pode ser verificado!');
  }
}
