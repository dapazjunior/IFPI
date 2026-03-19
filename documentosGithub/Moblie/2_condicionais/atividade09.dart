void main() {
  var leitura = 'alfabetizado'; // altere para 'analfabeto' para testar
  var idade = 18;               // altere para testar diferentes faixas etárias

  if (leitura == 'alfabetizado') {
    if (idade < 70) {
      if (idade < 16) {
        print('Você tem $idade. Você não tem idade para votar!');
      } else if ((idade >= 18) && (idade < 70)) {
        print('Você tem $idade. Seu voto é obrigatório !');
      } else if ((idade >= 16) && (idade < 18)) {
        print('Você tem $idade. Seu voto é facultativo!');
      }
    } else {
      print('Você tem $idade. Seu voto é facultativo!');
    }
  } else {
    print('Você é $leitura. Seu voto é facultativo');
  }
}
