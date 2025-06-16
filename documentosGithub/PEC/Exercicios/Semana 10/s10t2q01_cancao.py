def main():
    """Função principal que canta bugs de 99 até 250."""
    cantar_bugs(99, 250)


def cantar_bugs(inicio, fim):
    """Canta a música dos bugs no software, do número 'inicio' até 'fim'(inclusive)."""
    for i in range(inicio, fim + 1):
        print(f'{i} bugs no software, pegue um deles e conserte...')


if __name__ == "__main__":
    main()
