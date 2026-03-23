import random

def main():
    lista1 = grava_lista(5)
    lista2 = grava_lista(5)

    print(f"Lista {lista1}: {esta_ordenada(lista1)}")
    print(f"Lista {lista2}: {esta_ordenada(lista2)}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def esta_ordenada(lista):
    for i in range(len(lista) - 1):
        if lista[i] > lista[i + 1]:
            return False

    return True


if __name__ == "__main__":
    main()