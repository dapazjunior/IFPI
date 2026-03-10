import random
def main():
    max_lista = 100
    
    lista = grava_lista(max_lista)

    print(f"A lista de números é:\n{lista}")
    lista_pares = conta_pares(lista)
    lista_impares = conta_impares(lista)

    num_pares = len(lista_pares)
    num_impares = len(lista_impares)

    print(f"a) A quantidade de números pares é: {num_pares}.")
    print(f"b) Os números pares são:\n{lista_pares}.")
    print(f"c) A quantidade de números ímpares é: {num_impares}.")
    print(f"d) Os números ímpares são:\n{lista_impares}.")


def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(0, 1000))
    
    return lista


def conta_pares(lista):
    lista_pares = []

    for num in lista:
        if num % 2 == 0:
            lista_pares.append(num)

    return lista_pares


def conta_impares(lista):
    lista_impares = []

    for num in lista:
        if num % 2 != 0:
            lista_impares.append(num)

    return lista_impares


if __name__ == "__main__":
    main()
