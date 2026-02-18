# Questão 14
def main():
    n = int(input("Digite um número inteiro e positivo N:\n>>> "))
    s = calcular_soma(n)
    print(f"S = {s:.4f}")


def calcular_soma(n):
    s = 1
    fat = 1
    for i in range(1, n + 1):
        fat *= i
        s += 1 / fat
    return s


def fatorial(n):
    if n == 0 or n == 1:
        return 1
    fat = 1
    for i in range(2, n + 1):
        fat *= i
    return fat


if __name__ == "__main__":
    main()

