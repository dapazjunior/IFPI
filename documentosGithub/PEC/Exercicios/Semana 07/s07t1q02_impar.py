def main():
    """Lê um inteiro e informa se ele é ímpar"""

    #Entrada de dados
    numero = int(input())

    #Processamento
    resultado = eh_impar(numero)

    #Saída de dados
    print(resultado)


def eh_impar(valor):
    """Retorna True se o valor for ímpar, caso contrário False."""
    impar = (valor % 2) != 0
    return impar


if __name__ == "__main__":
    main()