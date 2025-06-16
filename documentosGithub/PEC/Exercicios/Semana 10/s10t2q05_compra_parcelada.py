def main():
    """Função principal que lê um valor e exibe as opções de parcelamento."""
    valor = float(input())

    calcular_parcelamentos(valor)


def calcular_parcelamentos(valor):
    """Recebe um valor e exibe as opções de parcelamento de 1 até 24 vezes,
    mostrando o valor de cada parcela."""
    for parcela in range(1, 25):
        print(f'{parcela}x de R$ {(valor / parcela):.2f}')


if __name__ == "__main__":
    main()
