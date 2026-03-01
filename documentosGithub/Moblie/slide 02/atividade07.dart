void main() {
  int x = 3;
  int y = 3;
  int z = 3;

  if (x == y || x == z || y == z)
    print("Está proibido o uso de variáveis com valores iguais");
  else if (x > y && x > z)
    print("A variável x é a maior");
  else if (y > x && y > z)
    print("A variável y é a maior");
  else 
    print("A variável z é a maior");     
}