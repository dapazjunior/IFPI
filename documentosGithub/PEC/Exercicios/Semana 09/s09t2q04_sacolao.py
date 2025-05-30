def main():
    morangos = float(input())
    macas = float(input())

    preco = calulcar_preco(morangos, macas)

    print(f'{preco:.2f}')


def calulcar_preco(morangos, macas):
    if morangos <= 5:
        preco_morango = morangos * 2.5
    else:
        preco_morango = morangos * 2.2

    if macas <= 5:
        preco_maca = macas * 1.8
    else:
        preco_maca = macas * 1.5

    preco = preco_maca + preco_morango

    if (morangos + macas > 8) or ((preco_maca + preco_morango) > 25):
        preco = preco * .9
    

    return preco


if __name__ == "__main__":
    main()