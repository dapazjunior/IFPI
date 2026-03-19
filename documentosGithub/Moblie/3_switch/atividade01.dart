void main() {
  String status = 'não';

  switch (status) {
    case 'não':
      print('não pode ter cartão de credito');
      break;
    case 'sim':
      print('pode ter cartão de credito');
      break;
    default:
      print('Status não verificado');
  }
}
