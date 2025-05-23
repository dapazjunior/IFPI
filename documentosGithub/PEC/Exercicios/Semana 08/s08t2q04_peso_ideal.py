def main():
    """Lê altura e sexo, calcula o peso ideal e exibe."""

    #Entrada de dados
    altura = float(input())
    sexo = int(input())

    #Processamento e Saída de dados
    print(verificar_peso_ideal(altura, sexo))


def verificar_peso_ideal(altura, sexo):
    """Calcula e retorna o peso ideal.
    Parâmetros:
    - altura: altura da pessoa
    - sexo: 1 para masculino, 2 para feminino"""

    if sexo == 1:
        peso = (72.7 * altura) - 58
    if sexo == 2:
        peso = (62.1 * altura) - 44.7

    return f"{peso:.2f}"


if __name__ == "__main__":
    main()