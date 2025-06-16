def main():
    """Função principal que canta bugs de 1 até 250,
    de 7 em 7, usando o nome 'sete' na música."""
    cantar_bugs(1, 250, 7, 'sete')

    print("Vamos fazer mais um café!")


def cantar_bugs(inicio, fim, passo, nome):
    """Canta a música dos bugs no software, do 'inicio' até 'fim',
    com incremento definido em 'passo' e usando 'nome' para
    indicar quantos bugs foram consertados por vez."""
    for i in range(inicio, fim + 1, passo):
        print(f'{i} bugs no software, pegue {nome} deles e conserte...')
        print('Tecle "Ctrl+F5"')


if __name__ == "__main__":
    main()
