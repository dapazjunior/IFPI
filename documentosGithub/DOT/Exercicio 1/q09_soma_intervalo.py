def main():
    n1 = int(input("Digite o primeiro número:\n>>> "))
    n2 = int(input("Digite o segundo número:\n>>> "))

    soma = soma_intervalo(n1, n2)
    print(f"A soma do intervalo [{n1}, {n2}] é: {soma}")


def soma_intervalo(a, b):
    soma = 0
    for i in range(a, b + 1):
        soma += i
    return soma


if __name__ == "__main__":
    main()
