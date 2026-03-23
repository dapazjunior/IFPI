import random

def main():
    lista = grava_lista(10)
    resultado = maior_soma_repetidos(lista)
    print(f"Lista: {lista}")
    print(f"Maior soma dos números que se repetem: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(-10, 10))

    return lista


def maior_soma_repetidos(lista):
    somados = []
    maior = 0

    for num in lista:
        if num not in somados:
            contador = 0
            for item in lista:
                if item == num:
                    contador += 1
            if contador > 1:
                somados.append(num)
                soma = num * contador
                if soma > maior:
                    maior = soma

    return maior


if __name__ == "__main__":
    main()