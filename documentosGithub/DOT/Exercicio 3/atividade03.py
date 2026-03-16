import random


def main():
    qtd_lista = 10

    lista = grava_lista(qtd_lista)
    lista_sem_repeticao = remover_repetidos(lista)

    print(f"Lista original: {lista}")
    print(f"Lista sem repetição: {lista_sem_repeticao}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 15))

    return lista


def remover_repetidos(lista):
    sem_repeticao = []

    for num in lista:
        if num not in sem_repeticao:
            sem_repeticao.append(num)

    return sem_repeticao


if __name__ == "__main__":
    main()