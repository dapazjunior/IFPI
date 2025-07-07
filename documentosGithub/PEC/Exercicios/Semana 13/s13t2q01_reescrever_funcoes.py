def main():
    lista = ler_lista()  # lê os números até digitar 0

    print(lista)  # mostra a lista lida
    
    print(comprimento(lista))  # mostra quantos itens tem na lista
    print(inverter(lista))  # mostra a lista invertida
    print(minimo(lista))  # mostra o menor valor
    print(maximo(lista))  # mostra o maior valor
    print(soma(lista))  # mostra a soma dos valores


# lê números até digitar 0 e monta a lista
def ler_lista():
    lista = []
    while True:
        item = int(input())
        if item == 0:
            break
        lista.append(item)

    return lista 


# conta quantos itens tem na lista
def comprimento(lista):
    cont = 0
    for _ in lista:
        cont += 1
    return cont


# cria uma nova lista invertendo a original
def inverter(lista):
    invertida = []
    for item in lista:
        invertida.insert(0, item)
    return invertida


# acha o menor valor da lista
def minimo(lista):
    min = float("inf")
    for num in lista:
        if num < min:
            min = num
    return min


# acha o maior valor da lista (OBS: tem erro no código original, deveria usar maximo)
def maximo(lista):
    max = float("-inf")
    for num in lista:
        if num > max:
            max = num
    return max


# soma todos os valores da lista
def soma(lista):
    soma = 0
    for num in lista:
        soma += num
    return soma


if __name__ == "__main__":
    main()
