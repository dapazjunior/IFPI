def main():
    populacao_dodo = int(input())

    atualizar_populacao(populacao_dodo)


def atualizar_populacao(populacao_inicial):
    ano = 1600
    populacao = populacao_inicial

    while populacao > 0.1 * populacao_inicial:
        nascimentos = calcular_nascimentos(populacao)
        mortes = calcular_mortes(populacao)
        populacao += nascimentos - mortes
        print(f'{ano},{nascimentos:.0f},{mortes:.0f},{populacao:.0f}')
        ano += 1


def calcular_nascimentos(populacao):
    return 0.01 * populacao


def calcular_mortes(populacao):
    return 0.06 * populacao


if __name__ == "__main__":
    main()