void main() {
  var idade = 17;
  var sexo = 'masculino'; // altere para 'feminino' para ver o outro resultado

  if (idade <= 17) {
    print('Você é menor de idade! Você tem $idade anos.');
    if (sexo == 'masculino') {
      print('Você é do sexo $sexo');
    }
  }

  print('Finalizou o programa');
}
