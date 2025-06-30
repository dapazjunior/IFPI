def main():
    cont = 1        
    media = 0       # a média começa zerada

    while True:
        num = int(input())  # lê o número
        if num == 0:
            break  # se digitar 0, para tudo
        
        media = calcular_media_acumulada(media, num, cont)  # chama a função que calcula a nova média
        cont += 1  # aumenta o contador

    print(f'{media:.2f}')  # mostra a média com duas casas


def calcular_media_acumulada(media_anterior, novo_numero, quantidade):
    # cálculo da média acumulada
    return (novo_numero + media_anterior * (quantidade - 1)) / quantidade


if __name__ == "__main__":
    main()

