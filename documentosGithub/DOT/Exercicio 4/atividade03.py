import random

def main():
    lista = grava_lista(12)
    resultado = maior_soma_dois(lista)
    print(f"Lista: {lista}")
    print(f"Maior soma de 2 elementos consecutivos: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(-20, 20))

    return lista


def maior_soma_dois(lista):
    maior = float('-inf')

    for i in range(len(lista) - 1):
        soma = lista[i] + lista[i + 1]
        if soma > maior:
            maior = soma

    return maior


if __name__ == "__main__":
    main()