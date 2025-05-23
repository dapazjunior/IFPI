def main():
    """Lê três notas, calcula a média, ajusta a média se for o caso e exibe a média final."""

    #Entrada de dados
    n1 = float(input())
    n2 = float(input())
    n3 = float(input())


    #Processamento
    media = calcular_media(n1, n2, n3)
    media = ajustar_media(n3, media)
    

    #Saída de dados
    print(f'{media:.2f}')


def calcular_media(num1, num2, num3):
    """Retorna a média aritmética de três valores."""

    media = (num1 + num2 + num3) / 3
    return media


def ajustar_media(nota, media):
    """Ajusta a média somando 1 ponto se a última nota for maior que 8. Valor máximo da média é 10."""

    if nota > 8:
        media += 1
        if media >= 10:
            media = 10
    return media


if __name__ == "__main__":
    main()