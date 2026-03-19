void main() {
  // Chamada com todos os parâmetros
  print('Bemvindo ao Petshop!');
  bicho("cachorro", apelido: 'totó', raca: 'doberman', idade: 36.0);

  print('---');

  // Chamada sem os parâmetros opcionais (usará os valores padrão)
  print('Bemvindo ao Petshop!');
  bicho("cachorro");
}

void bicho(String texto, {String? apelido, String? raca, double? idade}) {
  print('Seu bichinho é um :');
  print(texto);
  print('Seu nome é:');
  print(apelido ?? "desconhecido");
  print('A raça do bichinho é:');
  print(raca ?? "desconhecida");
  print('Sua idade:');
  print(idade ?? 0);
}
