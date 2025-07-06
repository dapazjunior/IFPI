def main():
    lista_a = ler_lista(20)
    lista_b = ler_lista(20)

    lista_c = somar_listas(lista_a, lista_b)
    print(lista_a)
    print(lista_b)
    print(lista_c)



def ler_lista(qtd):
    lista = []

    for _ in range(qtd):
        item = int(input())
        lista.append(item)

    return lista 


def somar_listas(lista1, lista2):
    qtd = len(lista1)
    lista_soma = []

    for i in range(qtd):
        lista_soma.append(lista1[i] + lista2[i])
    
    return lista_soma


if __name__ == "__main__":
    main()