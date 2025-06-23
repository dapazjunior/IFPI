def main():
    maior = 0
    menor = float("inf")

    while True:
        num = int(input())
        if num == 0:
            break
        
        if eh_maior(num, maior):
            maior = num

        if eh_menor(num, menor):
            menor = num
    
    print(maior)
    print(menor)


def eh_maior(num, maior):
    return num > maior


def eh_menor(num, menor):
    return num < menor


if __name__ == "__main__":
    main()