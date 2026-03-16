import random


def main():
    qtd_lista = 15

    lista = grava_lista(qtd_lista)

    lista_div3 = filtrar_divisíveis(lista, 3)
    lista_div5 = filtrar_divisíveis(lista, 5)

    print(f"Lista original: {lista}")
    print(f"a) Divisíveis por 3: {lista_div3}")
    print(f"b) Divisíveis por 5: {lista_div5}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista


def filtrar_divisíveis(lista, divisor):
    resultado = []

    for num in lista:
        if num % divisor == 0:
            resultado.append(num)

    return resultado


if __name__ == "__main__":
    main()