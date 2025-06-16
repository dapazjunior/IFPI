def main():
    """Função principal que recebe 100 valores e exibe a quantidade de pares e ímpares."""
    pares, impares = receber_e_contar_100_valores()

    print(pares)
    print(impares)


def receber_e_contar_100_valores():
    """Recebe 100 números inteiros do usuário.
    Conta quantos são pares e quantos são ímpares (desconsiderando zeros).
    Retorna a quantidade de pares e ímpares."""
    cont_pares = 0
    cont_impares = 0

    for _ in range(100):
        num = int(input())

        if num != 0:
            if eh_par(num):
                cont_pares += 1
            else:
                cont_impares += 1

    return cont_pares, cont_impares


def eh_par(numero):
    """Retorna True se o número for par, caso contrário retorna False."""
    return numero % 2 == 0


def eh_impar(numero):
    """Retorna True se o número for ímpar, caso contrário retorna False."""
    return numero % 2 != 0


if __name__ == "__main__":
    main()
