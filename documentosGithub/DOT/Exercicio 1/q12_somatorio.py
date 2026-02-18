def main():
    num = int(input("Digite um número inteiro e positivo:\n>>> "))
    somatoria = calcular_somatoria(num)
    print(f"O somatório de {num} é: {somatoria}")


def calcular_somatoria(n):
    soma = 0
    for i in range(1, n + 1):
        soma += i
    return soma


if __name__ == "__main__":
    main()
