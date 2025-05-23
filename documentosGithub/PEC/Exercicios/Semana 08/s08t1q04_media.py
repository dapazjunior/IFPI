def main():
    """Lê 5 números, calcula a média e exibe quais números estão acima da média."""

    #Entrada de dados
    n1 = float(input())
    n2 = float(input())
    n3 = float(input())
    n4 = float(input())
    n5 = float(input())

    #Processamento
    media = calcular_media(n1, n2, n3, n4, n5)

    #Saída de dados
    print(f'{media:.2f}')
    print_se_maior(n1, media)
    print_se_maior(n2, media)
    print_se_maior(n3, media)
    print_se_maior(n4, media)
    print_se_maior(n5, media)


def calcular_media(num1, num2, num3, num4, num5):
    """Recebe 5 números. Retorna a média aritmética deles."""
    media = (num1 + num2 + num3 + num4 + num5) / 5
    return media


def print_se_maior(num, media):
    """Se o número for maior que a média, exibe ele."""
    if num > media:
        print(f'{num}')


if __name__ == "__main__":
    main()