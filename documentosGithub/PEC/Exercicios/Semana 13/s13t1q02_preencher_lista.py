def main():
    n = int(input())
    lista = []

    # cria a lista com zeros
    lista = lista_com_0(n, lista)
    print(lista)

    # coloca os números de 1 até n
    lista = lista_1_a_n(n, lista)
    print(lista)

    # lê n números e guarda na lista
    lista = lista_n_termos(n, lista)
    print(lista)

    # lê n números e guarda na lista invertendo a ordem
    lista = lista_invertida(n)
    print(lista)


def lista_com_0(n, lista):
    for _ in range(n):
        lista.append(0)
    return lista


def lista_1_a_n(n, lista):
    for i in range(n):
        lista[i] = i + 1
    return lista


def lista_n_termos(n, lista):
    for i in range(n):
        num = int(input())
        lista[i] = num
    return lista


def lista_invertida(n):
    lista = []
    for _ in range(n):
        num = int(input())
        lista.insert(0, num)  # insere no começo, pra inverter
    return lista


if __name__ == "__main__":
    main()
