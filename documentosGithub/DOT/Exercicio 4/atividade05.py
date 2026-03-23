import random

def main():
    lista = grava_lista(10)
    resultado = soma_cumulativa(lista)
    print(f"Lista original: {lista}")
    print(f"Soma cumulativa: {resultado}")

def grava_lista(num):
    lista = []

    for _ in range(num):
        lista.append(random.randint(1, 100))

    return lista

def soma_cumulativa(lista):
    cumulativa = []
    soma = 0

    for num in lista:
        soma += num
        cumulativa.append(soma)

    return cumulativa


if __name__ == "__main__":
    main()