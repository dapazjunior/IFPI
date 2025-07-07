def main():
    lista = ler_lista()  # lê a lista até digitar 0
    valor = int(input())  # lê o valor que vamos contar

    print(lista)  # mostra a lista lida
    print(valor)  # mostra o valor que vamos procurar
    print(contar(lista, valor))  # mostra quantas vezes o valor aparece


# lê os números até digitar 0 e monta a lista
def ler_lista():
    lista = []
    while True:
        item = int(input())
        if item == 0:
            break
        lista.append(item)

    return lista 


# conta quantas vezes o item aparece na lista
def contar(lista, item):
    cont = 0
    for valor in lista:
        if valor == item:
            cont += 1
    return cont


if __name__ == "__main__":
    main()
