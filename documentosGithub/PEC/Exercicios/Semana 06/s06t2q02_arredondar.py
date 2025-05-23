def main():
    """Lê um valor em dinheiro e imprime o valor arredondado para o inteiro mais próximo"""

    valor = float(input())
    inteiro = arredondar_valor(valor)
    print(inteiro)


def arredondar_valor(valor):
    """Arredonda e retorna o valor para o número inteiro mais próximo"""

    valor = round(valor)
    return valor


if __name__ == "__main__":
    main()