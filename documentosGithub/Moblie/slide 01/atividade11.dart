void main() {
  Map produtos = {
    1: 'tênis',
    2: 'calça',
    3: 'blusa',
    4: 'cueca',
    5: 'calcinha'
  };

  // print(produtos[1]);

  var chaves = produtos.keys;
  var valores = produtos.values;

  print(chaves);
  print(valores);
}