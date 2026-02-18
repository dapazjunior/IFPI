def main():
    n = int(input("Digite um número inteiro e positivo N:\n>>> "))
    s = calcular_soma(n)
    print(f"S = {s:.4f}")


def calcular_soma(n):
    s = 0
    for i in range(1, n + 1):
        s += 1 / i
    return s


if __name__ == "__main__":
    main()
