def main():
    """Lê as quantidades de morangos e maçãs e calcula o preço total."""
    # Entrada de dados
    morangos = float(input())
    macas = float(input())

    # Processamento
    preco = calcular_preco(morangos, macas)

    # Saída de dados
    print(f'{preco:.2f}')


def calcular_preco(morangos, macas):
    """Calcula o preço total com possíveis descontos."""
    if morangos <= 5:
        preco_morango = morangos * 2.5
    else:
        preco_morango = morangos * 2.2

    if macas <= 5:
        preco_maca = macas * 1.8
    else:
        preco_maca = macas * 1.5

    preco = preco_maca + preco_morango

    if (morangos + macas > 8) or (preco > 25):
        preco = preco * 0.9

    return preco


if __name__ == "__main__":
    main()
