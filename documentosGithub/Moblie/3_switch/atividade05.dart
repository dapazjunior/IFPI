void main() {
  var nome = 'maria';
  String status = '01';

  switch (status) {
    case '01':
      if (nome == 'maria') {
        print('Uma mulher');
      } else if (nome == 'mario') {
        print('Um Homem');
      } else {
        print('Não reconhecemos este nome.');
      }
      break;
    case '02':
      if (nome == 'maria') {
        print('Secretaria');
      } else if (nome == 'mario') {
        print('Gerente');
      } else {
        print('Esta pessoa não trabalha em nossa empresa');
      }
      break;
    case '03':
      if (nome == 'maria') {
        print('Mora em Teresina');
      } else if (nome == 'mario') {
        print('Mora em Timon');
      } else {
        print('Não temos esta informação');
      }
      break;
    default:
      print('Status não verificado!');
  }
}
