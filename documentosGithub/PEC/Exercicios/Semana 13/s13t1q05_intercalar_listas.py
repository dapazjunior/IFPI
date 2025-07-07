def main():
    # gera duas listas com 25 números cada
    lista_a = gerar_lista(25)
    lista_b = gerar_lista(25)

    # intercala as duas listas numa terceira
    lista_c = intercalar_listas(lista_a, lista_b, 25)

    # exibe as listas
    print(lista_a)
    print(lista_b)
    print(lista_c)


# lê vários números e monta uma lista
def gerar_lista(num):
    lista = []
    for _ in range(num):
        termo = int(input())
        lista.append(termo)
    
    return lista


# intercala os elementos das duas listas
def intercalar_listas(lista1, lista2, tamanho):
    lista = []
    for i in range(tamanho):
        lista.append(lista1[i])  # adiciona um termo da primeira lista
        lista.append(lista2[i])  # adiciona um termo da segunda lista
    
    return lista


if __name__ == "__main__":
    main()
