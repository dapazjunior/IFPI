def main():
    # recebe todas as informações da função
    num_pessoas, media, menor, maior = processar_idades()

    print(num_pessoas)
    print(f'{media:.2f}')
    print(menor)
    print(maior)


def processar_idades():
    num_pessoas = 0
    soma_idades = 0
    maior = 0
    menor = float("+inf")

    while True:
        idade = int(input())  # lê a idade
        if idade == 0:
            break  # se for 0, para

        num_pessoas += 1
        soma_idades += idade

        if idade > maior:  # verifica a maior idade
            maior = idade
        if idade < menor:  # verifica a menor idade
            menor = idade

    media = calcular_media(soma_idades, num_pessoas)  # calcula a média com função separada

    return num_pessoas, media, menor, maior


def calcular_media(soma, quantidade):
    return soma / quantidade  # só divide a soma pela quantidade


if __name__ == "__main__":
    main()
