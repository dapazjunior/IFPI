def main():
    """Função principal que canta bugs começando de 99 até 0,
    decrementando de 11 em 11, usando o nome 'onze' na música."""
    cantar_bugs(99, 0, -11, 'onze')


def cantar_bugs(inicio, fim, passo, nome):
    """Canta a música dos bugs no software, começando em 'inicio' até 'fim',
    com passo definido (negativo para contagem decrescente),
    usando 'nome' para indicar quantos bugs foram consertados.
    Ao final, exibe a mensagem de software estabilizado."""
    for i in range(inicio, fim, passo):
        print(f'{i} bugs no software, pegue {nome} deles e conserte...')
        print('Tecle "Ctrl+F5"')

    if i <= 11:
        print("Sem erros no software! Está estabilizado!")


if __name__ == "__main__":
    main()
