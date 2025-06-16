def main():
    """Função principal que canta bugs de 1 até 250,
    adicionando a instrução de 'Ctrl+F5' e mensagem final."""
    cantar_bugs(1, 250)
    print("Vamos fazer mais um café!")


def cantar_bugs(inicio, fim):
    """Canta a música dos bugs no software, do número 'inicio' até 'fim'.
    Inclui a mensagem para pressionar "Ctrl+F5" após cada bug."""
    for i in range(inicio, fim + 1):
        print(f'{i} bugs no software, pegue um deles e conserte...')
        print('Tecle "Ctrl+F5"')


if __name__ == "__main__":
    main()
