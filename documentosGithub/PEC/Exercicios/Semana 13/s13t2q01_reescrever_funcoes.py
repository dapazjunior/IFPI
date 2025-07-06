def main():
    lista = ler_lista()

    print(lista)
    
    print(comprimento(lista))
    print(inverter(lista))
    print(minimo(lista))
    print(max(lista))
    print(soma(lista))


def ler_lista():
    lista = []

    while True:
        item = int(input())
        if item == 0:
            break
        lista.append(item)

    return lista 


def comprimento(lista):
    cont = 0

    for _ in lista:
        cont += 1
    
    return cont


def inverter(lista):
    invertida = []

    for item in lista:
        invertida.insert(0, item)
    
    return invertida


def minimo(lista):
    min = float("inf")

    for num in lista:
        if num < min:
            min = num
    
    return min


def maximo(lista):
    max = float("-inf")

    for num in lista:
        if num > max:
            max = num
    
    return max


def soma(lista):
    soma = 0

    for num in lista:
        soma += num
    
    return soma

if __name__ == "__main__":
    main()