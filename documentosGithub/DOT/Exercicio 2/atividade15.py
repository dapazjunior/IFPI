import random


def main():
    qtd_lista = 10

    lista_d = grava_lista(qtd_lista)
    lista_e = criar_lista_inversa(lista_d)

    print(f"Lista D: {lista_d}")
    print(f"Lista E (inversa de D): {lista_e}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def criar_lista_inversa(lista_d):
    lista_e = []

    for i in range(len(lista_d) - 1, -1, -1):
        lista_e.append(lista_d[i])

    return lista_e


if __name__ == "__main__":
    main()