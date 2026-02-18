def main():
    while True:
        num = float(input("Digite um número:\n>>> "))
        resultado = num ** 3
        print(f"O cubo de {num} é: {resultado:.2f}")

        resposta = ler_caractere()
        if resposta == 'N':
            break


def ler_caractere():
    while True:
        char = input("Deseja continuar? (S/N):\n>>> ").upper()
        if char == 'S' or char == 'N':
            return char
        else:
            print("Caractere inválido. Digite novamente")


if __name__ == "__main__":
    main()
