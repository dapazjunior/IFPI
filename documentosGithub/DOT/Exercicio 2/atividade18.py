import random


def main():
    qtd_lista = 10

    lista_x = grava_lista(qtd_lista)
    lista_r = copiar_negativos(lista_x)

    print(f"Lista X: {lista_x}")
    print(f"Lista R (negativos de X): {lista_r}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(-50, 50))

    return lista


def copiar_negativos(lista_x):
    lista_r = []

    for num in lista_x:
        if num < 0:
            lista_r.append(num)

    return lista_r


if __name__ == "__main__":
    main()