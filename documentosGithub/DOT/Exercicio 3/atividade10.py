import random


def main():
    qtd_lista = 20

    lista = grava_lista(qtd_lista)
    lista_reorganizada = reorganizar_lista(lista)

    print(f"Lista antes: {lista}")
    print(f"Lista depois: {lista_reorganizada}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def reorganizar_lista(lista):
    pares = []
    impares = []

    for num in lista:
        if num % 2 == 0:
            pares.append(num)
        else:
            impares.append(num)

    reorganizada = []

    for num in pares:
        reorganizada.append(num)

    for num in impares:
        reorganizada.append(num)

    return reorganizada


if __name__ == "__main__":
    main()