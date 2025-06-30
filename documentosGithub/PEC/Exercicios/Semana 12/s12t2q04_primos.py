def main():
    num = int(input())  # lê o número que queremos verificar

    print(eh_primo(num))  # mostra True ou False se for primo ou não


def eh_primo(num):
    multiplos = 0  # conta quantos divisores o número tem

    # verifica de 1 até o próprio número
    for c in range(1, num + 1):
        if (num % c == 0):  # se for divisor exato, conta
            multiplos += 1

    return multiplos == 2  # só é primo se tiver exatamente dois divisores


if __name__ == "__main__":
    main()
