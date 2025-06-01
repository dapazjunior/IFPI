def main():
    valor1 = float(input())
    valor2 = float(input())
    valor3 = float(input())

    print(verificar_valores(valor1, valor2, valor3))


def verificar_valores(v1, v2, v3):
    if v1 == v2 == v3:
        return "Todos os valores são iguais"
    if v1 == v2 or v2 == v3 or v1 == v3:
        return "Existem dois valores iguais e um diferente"
    return "Todos os valores são diferentes"


if __name__ == "__main__":
    main()