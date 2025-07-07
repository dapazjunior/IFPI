def main():
    soma, produto = 0, 1  # inicia a soma e o produto
    numeros = []  # lista vazia pra guardar os números

    # chama a função que processa os números
    soma, produto, numeros = processar_numeros(10, soma, produto, numeros)

    # imprime a lista, soma e produto
    print(numeros)
    print(soma)
    print(produto)


def processar_numeros(n, soma, produto, lista):
    # repete n vezes pra ler os números
    for _ in range(n):
        num = int(input())
        soma += num  # acumula a soma
        produto *= num  # multiplica no produto
        lista.append(num)  # adiciona o número na lista
    
    return soma, produto, lista  # retorna tudo


if __name__ == "__main__":
    main()
