def main():
    # chama a função que lê os números e separa em listas
    numeros, pares, impares = tratar_numeros()

    # exibe os resultados
    print(numeros)
    print(pares)
    print(impares)


# função que lê 20 números e separa em pares e ímpares
def tratar_numeros():
    numeros, pares, impares = [], [], []  # inicializa as 3 listas vazias

    for _ in range(20):
        num = int(input())  # lê o número digitado
        numeros.append(num)  # adiciona na lista geral

        if eh_par(num):
            pares.append(num)  # se for par, adiciona na lista de pares
        else:
            impares.append(num)  # se não for, coloca na de ímpares

    return numeros, pares, impares  # retorna todas as listas


# verifica se o número é par
def eh_par(num):
    return num % 2 == 0  # retorna True se for par


if __name__ == "__main__":
    main()
