def main():
    num = int(input())

    fatorial = calcular_fatorial(num)

    print(fatorial)


def calcular_fatorial(numero):
    fatorial = 1

    for _ in range(numero):
        fatorial *= numero
        numero -= 1

    return fatorial

if __name__ == "__main__":
    main()