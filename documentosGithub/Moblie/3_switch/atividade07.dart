void main() {
  var n = 1;
  Map nome = {'1': 'Rildo', '2': 'Cesar', '3': 'Lucas'};
  Map cargo = {'1': 'Gerente', '2': 'Servente', '3': 'Auditor'};
  Map idade = {'1': '42', '2': '35', '3': '25'};

  String status = '$n';

  switch (status) {
    case '1':
      print('Funcionário nº$n :');
      print('Nome: ' + nome['$n']);
      print('Cargo: ' + cargo['$n']);
      print('Idade: ' + idade['$n']);
      break;
    case '2':
      print('Funcionário nº$n :');
      print('Nome: ' + nome['$n']);
      print('Cargo: ' + cargo['$n']);
      print('Idade: ' + idade['$n']);
      break;
    case '3':
      print('Funcionário nº$n :');
      print('Nome: ' + nome['$n']);
      print('Cargo: ' + cargo['$n']);
      print('Idade: ' + idade['$n']);
      break;
    default:
      print('Não verificado!');
  }
}
