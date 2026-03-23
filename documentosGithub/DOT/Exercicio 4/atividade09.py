import random

def main():
    lista = [5, 4, 5, 7, 3, 4]
    resultado = eliminar_todos_repetidos(lista)
    print(f"Lista original: {lista}")
    print(f"Lista sem valores repetidos: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 10))

    return lista


def eliminar_todos_repetidos(lista):
    resultado = []

    for num in lista:
        contador = 0
        for item in lista:
            if item == num:
                contador += 1
        if contador == 1:
            resultado.append(num)

    return resultado


if __name__ == "__main__":
    main()