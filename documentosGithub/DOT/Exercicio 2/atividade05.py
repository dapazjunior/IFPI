import random


def main():
    qtd_lista = 10

    lista1 = grava_lista(qtd_lista)
    print(lista1)
    lista2 = grava_lista(qtd_lista)
    print(lista2)


    lista_intercalada = intercar_listas(lista1, lista2)
    print(lista_intercalada)

      

def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(1,100))
    
    return lista


def intercar_listas(lista1, lista2):
    intercalada = []

    for i in range(len(lista1)):
        intercalada.append(lista1[i])
        intercalada.append(lista2[i])
    
    return intercalada


if __name__ == "__main__":
    main()