import random


def main():
    qtd_lista = 20

    lista = grava_lista(qtd_lista)

    print(f"Lista: {lista}")

    soma = calcular_soma(lista)
    media = soma / qtd_lista

    acima_media = contar_acima_media(lista, media)

    print(f"Soma de todos os elementos: {soma}")
    print(f"Média dos valores: {media:.2f}")
    print(f"Quantidade de números acima da média: {acima_media}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def calcular_soma(lista):
    soma = 0

    for num in lista:
        soma += num

    return soma


def contar_acima_media(lista, media):
    contador = 0

    for num in lista:
        if num > media:
            contador += 1

    return contador


if __name__ == "__main__":
    main()