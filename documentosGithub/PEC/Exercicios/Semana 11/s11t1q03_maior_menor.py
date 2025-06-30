def main():
    maior = 0
    menor = float("inf")  # começa com o maior valor possível

    while True:
        num = int(input())  # lê um número
        if num == 0:  # se for 0, encerra
            break
        
        if eh_maior(num, maior):  # verifica se o número atual é maior
            maior = num

        if eh_menor(num, menor):  # verifica se o número atual é menor
            menor = num
    
    print(maior)
    print(menor)


def eh_maior(num, maior):
    return num > maior  # retorna True se o número é maior que o anterior


def eh_menor(num, menor):
    return num < menor  # retorna True se o número é menor que o anterior


if __name__ == "__main__":
    main()
