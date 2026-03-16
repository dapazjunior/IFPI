import random


def main():
    lista_r = grava_lista(5)
    lista_s = grava_lista(10)
    lista_x = combinar_listas(lista_r, lista_s)

    print(f"Lista R (5 elementos): {lista_r}")
    print(f"Lista S (10 elementos): {lista_s}")
    print(f"Lista X (15 elementos): {lista_x}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def combinar_listas(lista_r, lista_s):
    lista_x = []

    for elemento in lista_r:
        lista_x.append(elemento)

    for elemento in lista_s:
        lista_x.append(elemento)

    return lista_x


if __name__ == "__main__":
    main()