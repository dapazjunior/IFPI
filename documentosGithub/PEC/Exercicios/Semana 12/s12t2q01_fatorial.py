def main():
    num = int(input())  # número que queremos o fatorial

    fatorial = calcular_fatorial(num)

    print(fatorial)


def calcular_fatorial(numero):
    fatorial = 1
    # multiplica até chegar no 1
    for _ in range(numero):
        fatorial *= numero
        numero -= 1
    return fatorial


if __name__ == "__main__":
    main()
