import random

def main():
    lista1 = grava_lista(5)
    lista2 = grava_lista(5)

    print(f"Lista {lista1}: {tem_repeticao(lista1)}")
    print(f"Lista {lista2}: {tem_repeticao(lista2)}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 10))

    return lista


def tem_repeticao(lista):
    vistos = []

    for num in lista:
        if num in vistos:
            return True
        vistos.append(num)

    return False


if __name__ == "__main__":
    main()