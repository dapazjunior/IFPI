def main():
    lista_a = gerar_lista(25)
    lista_b = gerar_lista(25)

    lista_c = intercalar_listas(lista_a, lista_b, 25)

    print(lista_a)
    print(lista_b)
    print(lista_c)


def gerar_lista(num):
    lista = []
    for _ in range(num):
        termo = int(input())
        lista.append(termo)
    
    return lista


def intercalar_listas(lista1, lista2, tamanho):
    lista = []
    for i in range(tamanho):
        lista.append(lista1[i])
        lista.append(lista2[i])
    
    return lista


if __name__ == "__main__":
    main()