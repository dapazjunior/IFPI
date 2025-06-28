def main():
    num = int(input())

    sequencia = calcular_fibonacci(num)

    print(sequencia)


def calcular_fibonacci(num):
    anterior = 0
    atual = 1
    sep = ", "
    
    sequencia = str(anterior) + sep + str(atual)

    for _ in range (num-2):
        proximo = anterior + atual
        anterior = atual
        atual = proximo
        sequencia += sep + str(proximo)
    

    return f"{sequencia}"



if __name__ == "__main__":
    main()