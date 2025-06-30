def main():
    populacao_dodo = int(input())  # valor inicial da população

    simular_populacao(populacao_dodo)


def simular_populacao(populacao_inicial):
    ano = 1600
    populacao = populacao_inicial

    # continua enquanto a população for maior que 10% da original
    while populacao > 0.1 * populacao_inicial:
        nascimentos = calcular_nascimentos(populacao)
        mortes = calcular_mortes(populacao)
        populacao += nascimentos - mortes
        print(f'{ano},{nascimentos:.0f},{mortes:.0f},{populacao:.0f}')
        ano += 1


def calcular_nascimentos(populacao):
    return 0.01 * populacao  # 1% de nascimentos


def calcular_mortes(populacao):
    return 0.06 * populacao  # 6% de mortes


if __name__ == "__main__":
    main()
