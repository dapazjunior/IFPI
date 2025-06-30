def main():
    num = int(input())  # lê quantos termos queremos da sequência

    sequencia = calcular_fibonacci(num)  # calcula a sequência até o termo informado

    print(sequencia)  # exibe a sequência


def calcular_fibonacci(num):
    anterior = 0
    atual = 1
    sep = ", "  # separador para imprimir bonitinho

    # começa a sequência com os dois primeiros termos
    sequencia = str(anterior) + sep + str(atual)

    # gera os próximos termos da sequência
    for _ in range(num - 2):
        proximo = anterior + atual
        anterior = atual
        atual = proximo
        sequencia += sep + str(proximo)  # vai juntando os termos na string

    return sequencia  # retorna a sequência completa


if __name__ == "__main__":
    main()
