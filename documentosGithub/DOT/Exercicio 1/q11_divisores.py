def main():
    num = int(input("Digite um número inteiro e positivo:\n>>> "))
    divisores = contar_divisores(num)
    print(f"O número {num} tem {divisores} divisores")


def contar_divisores(n):
    contador = 0
    for i in range(1, n + 1):
        if n % i == 0:
            contador += 1
    return contador


if __name__ == "__main__":
    main()
