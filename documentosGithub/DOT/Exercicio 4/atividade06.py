def main():
    lista1 = [1, 2, 3]
    lista2 = [3, 7, 2]

    print(f"Lista {lista1}: {esta_ordenada(lista1)}")
    print(f"Lista {lista2}: {esta_ordenada(lista2)}")


def esta_ordenada(lista):
    for i in range(len(lista) - 1):
        if lista[i] > lista[i + 1]:
            return False

    return True


if __name__ == "__main__":
    main()