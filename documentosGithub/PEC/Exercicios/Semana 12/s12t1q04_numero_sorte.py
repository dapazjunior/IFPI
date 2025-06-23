def main():
    data_nascimento = input().strip()

    soma_digitos = somar_digitos(data_nascimento)

    print(soma_digitos)


def somar_digitos(numero):
    soma = 0

    for digito in numero:
        soma += int(digito)
    
    return soma


if __name__ == "__main__":
    main()