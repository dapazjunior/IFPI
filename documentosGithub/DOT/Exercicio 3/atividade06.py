import random


def main():
    qtd_lista = 10

    lista = grava_lista(qtd_lista)
    lista_y = criar_lista_y(lista)

    print(f"Lista original: {lista}")
    print(f"Lista Y: {lista_y}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 20))

    return lista


def criar_lista_y(lista):
    lista_y = []

    for num in lista:
        if num % 2 == 0:
            lista_y.append(num ** 2)
        else:
            lista_y.append(num * 3)

    return lista_y


if __name__ == "__main__":
    main()