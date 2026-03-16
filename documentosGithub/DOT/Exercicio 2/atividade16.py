import random


def main():
    qtd_lista = 10

    lista_x = grava_lista(qtd_lista)
    lista_y = criar_lista_y(lista_x)

    print(f"Lista X: {lista_x}")
    print(f"Lista Y: {lista_y}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 50))

    return lista


def criar_lista_y(lista_x):
    lista_y = []

    for i in range(len(lista_x)):
        if i % 2 == 0:
            lista_y.append(lista_x[i] / 2)
        else:
            lista_y.append(lista_x[i] * 3)

    return lista_y


if __name__ == "__main__":
    main()