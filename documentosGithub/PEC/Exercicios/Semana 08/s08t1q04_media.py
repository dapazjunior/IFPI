def main():
    """Lê três notas, calcula a média, ajusta a média se for o caso e exibe a média final."""

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
    """Retorna a média aritmética de cinco valores."""

    media = (num1 + num2 + num3 + num4 + num5) / 5
    return media


def print_se_maior(num, media):
    if num > media:
        print(f'{num}')


if __name__ == "__main__":
    main()