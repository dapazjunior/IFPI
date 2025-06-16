def main():
    """Função principal que calcula e exibe a média de 100 valores."""
    media = calcular_media(100)

    print(f"{media:.2f}")


def calcular_media(qtd_valores):
    """
    Solicita 'qtd_valores' números inteiros ao usuário.
    Calcula e retorna a média desses valores.
    """
    soma = 0

    for _ in range(qtd_valores):
        num = int(input())
        soma += num

    return soma / qtd_valores


if __name__ == "__main__":
    main()
