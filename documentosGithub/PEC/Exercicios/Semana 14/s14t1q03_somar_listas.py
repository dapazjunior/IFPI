def main():
    lista_a = ler_lista(20)  # lê a primeira lista com 20 números
    lista_b = ler_lista(20)  # lê a segunda lista com 20 números

    lista_c = somar_listas(lista_a, lista_b)  # soma as duas listas
    print(lista_a)
    print(lista_b)
    print(lista_c)


# lê uma lista com a quantidade informada
def ler_lista(qtd):
    lista = []
    for _ in range(qtd):
        item = int(input())
        lista.append(item)
    return lista 


# soma os valores das duas listas posição por posição
def somar_listas(lista1, lista2):
    qtd = len(lista1)
    lista_soma = []
    for i in range(qtd):
        lista_soma.append(lista1[i] + lista2[i])
    return lista_soma


if __name__ == "__main__":
    main()
