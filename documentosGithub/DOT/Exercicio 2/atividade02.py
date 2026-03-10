import random
def main():
    max_lista = 10

    lista = grava_lista(max_lista)

    print(f"A lista de números é:\n{lista}")

    lista_positivos = conta_positivos(lista)
    soma_positivos = sum(lista_positivos)

    lista_negativos = conta_negativos(lista)

    num_negativos = len(lista_negativos)

    print(f"A soma de números positivos é: {soma_positivos}")
    print(f"A quantidade de números negativos é: {num_negativos}.")
   

def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(round((random.uniform(-300, 300)), 2))
    
    return lista


def conta_positivos(lista):
    lista_positivos = []

    for num in lista:
        if num > 0:
            lista_positivos.append(num)

    return lista_positivos


def conta_negativos(lista):
    lista_negativos = []

    for num in lista:
        if num < 0:
            lista_negativos.append(num)

    return lista_negativos


if __name__ == "__main__":
    main()
