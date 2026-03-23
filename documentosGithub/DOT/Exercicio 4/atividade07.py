def main():
    lista1 = [1, 2, 3, 1]
    lista2 = [3, 7, 2, 4]

    print(f"Lista {lista1}: {tem_repeticao(lista1)}")
    print(f"Lista {lista2}: {tem_repeticao(lista2)}")


def tem_repeticao(lista):
    vistos = []

    for num in lista:
        if num in vistos:
            return True
        vistos.append(num)

    return False


if __name__ == "__main__":
    main()