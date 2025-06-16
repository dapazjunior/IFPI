def main():
    """Função principal que faz uma contagem de 10 em 10,
    de 10 até 1000, exibindo os números na mesma linha,
    separados por vírgula, e o último seguido de ponto."""
    for i in range(10, 1001, 10):
        if i != 1000:
            print(i, end=", ")
        else:
            print(i, end=".")


def contar_dez_em_dez(inicio, fim):
    """Realiza uma contagem de 10 em 10,
    do número 'inicio' até 'fim' (inclusive).
    Exibe os números na mesma linha, separados por vírgula,
    e o último seguido de ponto."""
    for i in range(inicio, fim + 1, 10):
        if i != fim:
            print(i, end=", ")
        else:
            print(i, end=".")


if __name__ == "__main__":
    main()
