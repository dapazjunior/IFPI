def main():
    a = float(input())
    b = float(input())
    c = float(input())

    valor = calcular(a, b, c)
    print(valor)


def calcular(valor1, valor2, valor3):
    resultado = 2 * valor1 + 5 * valor2 - valor3
    return resultado

main()