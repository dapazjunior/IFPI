import random

def main():
    lista = grava_lista(12)
    resultado = maior_soma_segmento(lista)
    print(f"Lista: {lista}")
    print(f"Maior soma de segmento: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(-20, 20))

    return lista


def maior_soma_segmento(lista):
    maior = float('-inf')

    for i in range(len(lista)):
        soma = lista[i]
        for j in range(i+1, len(lista)):
            soma += lista[j]
            if soma > maior:
                maior = soma

    return maior


if __name__ == "__main__":
    main()