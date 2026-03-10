import random

def main():
    qtd_lista = 10

    lista = grava_lista(qtd_lista)
    print(lista)

    num = 10

    if num in lista:
        print(f"O número {num} está na lista")
    else:
        print(f"O número {num} não está na lista")


def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(1,100))
    
    return lista


if __name__ == "__main__":
    main()