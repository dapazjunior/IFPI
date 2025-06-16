def main():
    """Função principal que inicia a contagem de 1 até 50."""
    contar(1, 50)


def contar(inicio, fim):
    """
    Realiza uma contagem do número 'inicio' até 'fim' (inclusive).
    Imprime cada número na tela.
    """
    for i in range(inicio, fim + 1):
        print(i)


if __name__ == "__main__":
    main()
