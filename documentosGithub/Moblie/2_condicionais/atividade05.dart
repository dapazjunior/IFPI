void main() {
  int ano = 1999;
  int idade = 2020 - ano;

  print('O ano digitado foi $ano. Você tem $idade ano(s) de idade');

  if (idade < 18) {
    print('Você é considerado menor de idade');
  } else {
    print('Você é considerado maior de idade');
  }
}
