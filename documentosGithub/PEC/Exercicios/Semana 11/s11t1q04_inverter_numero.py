def main():
    num = int(input())

    invertido = inverter_numero(num)

    print(invertido)


def inverter_numero(numero):
    num_invertido = ''

    while numero > 0 :
        num_invertido += str(numero % 10)
        numero = numero // 10

    return int(num_invertido)


if __name__ == "__main__":
    main()