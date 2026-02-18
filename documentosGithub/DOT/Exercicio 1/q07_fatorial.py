def main():
    num = int(input("Digite um número:\n>>> "))
    resultado = fatorial(num)
    print(f"O fatorial de {num} é: {resultado}")


def fatorial(n):
    if n == 0 or n == 1:
        return 1
    fat = 1
    for i in range(2, n + 1):
        fat *= i
    return fat


if __name__ == "__main__":
    main()
