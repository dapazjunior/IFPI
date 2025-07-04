def main():
    soma, produto = 0, 1
    numeros = []

    soma, produto, numeros = processar_numeros(10, soma, produto, numeros)

    print(numeros)
    print(soma)
    print(produto)

def processar_numeros(n, soma, produto, lista):
    for _ in range(n):
        num = int(input())
        soma += num
        produto *= num
        lista.append(num)
    
    return soma, produto, lista

if __name__ == "__main__":
    main()