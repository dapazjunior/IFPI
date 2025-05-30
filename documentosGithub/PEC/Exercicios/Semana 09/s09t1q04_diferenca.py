def main():
    valor1 = int(input())
    valor2 = int(input())
    valor3 = int(input())

    print(verificar_diferenca(valor1, valor2, valor3))


def verificar_diferenca(v1, v2, v3):
    if abs(subtracao(v1, v2)) <= abs(subtracao(v1, v3)):
        return abs(subtracao(v1, v2))
    else:
        return abs(subtracao(v1, v3))


def subtracao(v1, v2):
    return v1 - v2


if __name__ == "__main__":
    main()