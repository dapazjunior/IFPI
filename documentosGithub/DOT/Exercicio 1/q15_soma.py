# Questão 15
def main():
    n = int(input("Digite um número inteiro e positivo N:\n>>> "))
    s = calcular_soma(n)
    print(f"S = {s:.4f}")


def calcular_soma(n):
    s = 0
    for t in range(1, n + 1):
        numerador = t ** 2 + 1
        denominador = t + 3
        s += numerador / denominador
    return s


if __name__ == "__main__":
    main()
