def main():
    data_nascimento = input().strip()  # pega a data como string

    soma_digitos = somar_digitos(data_nascimento)

    print(soma_digitos)


def somar_digitos(numero):
    soma = 0
    for digito in numero:
        soma += int(digito)  # soma todos os dígitos um por um
    return soma


if __name__ == "__main__":
    main()
