import random


def main():
    qtd_lista = 10

    lista_c = grava_lista(qtd_lista)
    print(f"Lista C original: {lista_c}")

    lista_c = substituir_negativos(lista_c)
    print(f"Lista C modificada: {lista_c}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(-50, 50))

    return lista


def substituir_negativos(lista):
    for i in range(len(lista)):
        if lista[i] < 0:
            lista[i] = 0

    return lista


if __name__ == "__main__":
    main()