import random


def main():
    qtd_lista = 10

    lista1 = grava_lista(qtd_lista)
    lista2 = grava_lista(qtd_lista)
    lista_comuns = elementos_comuns(lista1, lista2)

    print(f"Lista 1: {lista1}")
    print(f"Lista 2: {lista2}")
    print(f"Elementos comuns: {lista_comuns}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 20))

    return lista


def elementos_comuns(lista1, lista2):
    comuns = []

    for num in lista1:
        if num in lista2 and num not in comuns:
            comuns.append(num)

    return comuns


if __name__ == "__main__":
    main()