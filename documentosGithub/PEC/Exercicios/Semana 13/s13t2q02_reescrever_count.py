def main():
    lista = ler_lista()
    valor = int(input())

    print(lista)
    print(valor)
    print(contar(lista, valor))


def ler_lista():
    lista = []

    while True:
        item = int(input())
        if item == 0:
            break
        lista.append(item)

    return lista 


def contar(lista, item):
    cont = 0

    for valor in lista:
        if valor == item:
            cont += 1
    
    return cont


if __name__ == "__main__":
    main()