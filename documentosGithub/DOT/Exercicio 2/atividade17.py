import random


def main():
    qtd_lista = 10

    lista_w = grava_lista(qtd_lista)
    print(f"Lista W: {lista_w}")

    valor_v = int(input("Digite o valor V a ser buscado: "))

    posicoes = buscar_valor(lista_w, valor_v)

    if not posicoes:
        print(f"O valor {valor_v} não ocorre na lista W.")
    else:
        print(f"O valor {valor_v} ocorre {len(posicoes)} vez(es) na lista W.")
        print(f"Posições encontradas: {posicoes}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 10))

    return lista


def buscar_valor(lista_w, valor):
    posicoes = []

    for i in range(len(lista_w)):
        if lista_w[i] == valor:
            posicoes.append(i)

    return posicoes


if __name__ == "__main__":
    main()