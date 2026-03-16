void main() {
  
  print(verificarMenor(5, 7, 2));
  
  }

  int verificarMenor(int n1, int n2, int n3){
    int menor = n1;
    
    if (n2 < menor) {
      menor = n2;
    }
    
    if (n3 < menor) {
      menor = n3;
    }
    
    return menor;
  }