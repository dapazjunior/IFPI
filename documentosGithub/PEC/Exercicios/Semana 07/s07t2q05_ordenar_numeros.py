def main():
    """Lê três inteiros, ordena em ordem crescente e imprime um em cada linha."""

    #Entrada de dados
    num1 = int(input())
    num2 = int(input())
    num3 = int(input())

    #Processamento
    menor, meio, maior = ordenar_numeros(num1, num2, num3)

    #Saída de dados
    print(menor)
    print(meio)
    print(maior)


def ordenar_numeros(numero1, numero2, numero3):
    """Retorna os números inseridos em ordem crescente."""

    aux1 = numero1
    aux2 = numero2
    aux3 = numero3

    numero1 = min(aux1, aux2, aux3)
    numero3 = max(aux1, aux2, aux3)
    numero2 = (aux1 + aux2 + aux3) - numero1 - numero3
    
    return numero1, numero2, numero3


if __name__ == "__main__":
    main()