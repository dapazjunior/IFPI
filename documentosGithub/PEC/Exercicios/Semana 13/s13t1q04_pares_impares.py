def main():
    numeros, pares, impares = tratar_numeros()

    print(numeros)
    print(pares)
    print(impares)


def tratar_numeros():
    numeros, pares, impares = [], [], []

    for _ in range (20):
        num = int(input())
        numeros.append(num)

        if eh_par(num):
            pares.append(num)
        else:
            impares.append(num)

    return numeros, pares, impares


def eh_par(num):
    return num % 2 == 0

if __name__ == "__main__":
    main()