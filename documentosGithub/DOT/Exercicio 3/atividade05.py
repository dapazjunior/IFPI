import random


def main():
    qtd_lista = 10

    lista = grava_lista(qtd_lista)
    print(lista)

    maior = max(lista)
    print(f'O maior é {maior} e sua posição é {lista.index(maior)}')

    segundo_maior, posicao_segundo = verificar_segundo_maior(lista)

    print(f'O segundo maior é {segundo_maior} e sua posição é {posicao_segundo}')


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def verificar_segundo_maior(lista):
    maior = max(lista)
    segundo = float('-inf')
    posicao_segundo = -1

    for i in range(len(lista)):
        if lista[i] < maior and lista[i] > segundo:
            segundo = lista[i]
            posicao_segundo = i

    return segundo, posicao_segundo


if __name__ == "__main__":
    main()
