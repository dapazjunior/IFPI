import random

def main():
    lista = grava_lista(8)
    resultado = eliminar_repeticoes(lista)
    print(f"Lista original: {lista}")
    print(f"Lista sem repetições: {resultado}")


def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 10))

    return lista


def eliminar_repeticoes(lista):
    sem_repeticao = []

    for num in lista:
        if num not in sem_repeticao:
            sem_repeticao.append(num)

    return sem_repeticao


if __name__ == "__main__":
    main()