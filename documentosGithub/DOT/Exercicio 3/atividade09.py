import random

def main():
    qtd_lista = 20

    lista = grava_lista(qtd_lista)
    print(lista)

    lista_ordenada = ordenar_lista(lista)
    print(lista_ordenada)

       
def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(1,100))
    
    return lista


def ordenar_lista(lista):
    nova_lista = []

    for num in lista:
        if num % 2 == 0:
            nova_lista.append(num)
    
    for num in lista:
        if num % 2 != 0:
            nova_lista.append(num)
    
    return nova_lista


if __name__ == "__main__":
    main()