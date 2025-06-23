def main():
    num_pessoas = 0
    soma_idades = 0
    maior = 0
    menor = float("+inf")
    idade = None

    while True:
        idade = int(input())
        if idade == 0:
            break

        num_pessoas += 1
        soma_idades += idade

        if idade > maior:
            maior = idade
        if idade < menor:
            menor = idade
    
    media = soma_idades / num_pessoas

    print(num_pessoas)
    print(f'{media:.2f}')
    print(menor)
    print(maior)


if __name__ == "__main__":
    main()