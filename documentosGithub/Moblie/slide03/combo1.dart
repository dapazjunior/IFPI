void main() {
  // boasvindas();
  // print(somador(10, 30));
  // print(calcularArea(1));
  print(areaRetangulo(4, 6));
  }

  double areaRetangulo(double b, double h) => b * h;
  
  void boasvindas(){
    print("Sejam bem-vindos ao Sistema!");
  }

  int somador(int n1, int n2){
    int res = n1 + n2;
    
    return res;
  }

  //double calcularArea(double raio) {
  //  double circulo = 3.14 * raio * raio;
  //  return circulo;}

  double calcularArea(double raio) => 3.14 * raio * raio;