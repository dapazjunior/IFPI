def main():
    """Função principal que encontra e exibe o maior valor entre 100 números."""
    maior = verificar_maior(100)

    print(maior)


def verificar_maior(qtd_valores):
    """Recebe 'qtd_valores' números inteiros do usuário.
    Retorna o maior número informado."""
    maior = float("-inf")

    for _ in range(qtd_valores):
        num = int(input())

        if num > maior:
            maior = num

    return maior


if __name__ == "__main__":
    main()
