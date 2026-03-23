import random

def main():
    lista = grava_lista(6)
    resultado = mais_proximo_da_media(lista)
    print(f"Lista: {lista}")
    print(f"Valor mais próximo da média: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def mais_proximo_da_media(lista):
    soma = 0

    for num in lista:
        soma += num

    media = soma / len(lista)

    mais_proximo = lista[0]

    for num in lista:
        if abs(num - media) < abs(mais_proximo - media):
            mais_proximo = num

    return mais_proximo


if __name__ == "__main__":
    main()