import random

def main():
    lista = grava_lista(10)
    contar_ocorrencias(lista)


def contar_ocorrencias(lista):
    contados = []

    for num in lista:
        if num not in contados:
            contados.append(num)
            contador = 0
            for item in lista:
                if item == num:
                    contador += 1
            print(f"Número {num}: {contador} vez(es)")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 10))

    return lista


if __name__ == "__main__":
    main()