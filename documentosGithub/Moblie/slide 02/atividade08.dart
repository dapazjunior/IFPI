void main() {
  int idade = 14;
  bool analfabeto = false;

  if (idade < 16) {
    print("Você tem $idade anos. Você não tem idade pra votar.");
  } else if (analfabeto) {
      print("Você é analfabeto. Seu voto é facultativo.");
  } else if (idade < 18) {
      print("Você tem $idade anos. Seu voto é facultativo.");
  } else if (idade < 70) {
     print("Você tem $idade anos. Seu voto é obrigatório.");
  } else {
     print("Você tem $idade anos. Seu voto é facultativo.");
  }
}