def main():
    atletas, alturas = ler_time()

    nome_mais_alto, altura_mais_alto = verificar_mais_alto(atletas, alturas)

    print("JOGADOR MAIS ALTO DO TIME")
    print(nome_mais_alto)
    print(f"{altura_mais_alto:.2f}")

    print("ALTURA MÉDIA DO TIME")
    media = calcular_media(alturas)
    print(f'{media:.2f}')

    maiores, alturas_maiores = maiores_que_media(atletas, alturas, media)
    print("JOGADORES MAIS ALTOS QUE A MÉDIA DO TIME")
    
    for i in range(len(maiores)):
        print(maiores[i])
        print(f"{alturas_maiores[i]:.2f}")


def ler_time():
    atletas = []
    alturas = []

    for _ in range(12):
        atleta = input().strip()
        altura = float(input())

        atletas.append(atleta)
        alturas.append(altura)

    return atletas, alturas


def verificar_mais_alto(atletas, alturas):
    mais_alto = 0
    indice = -1

    for i in range(12):
        if alturas[i] > mais_alto:
            mais_alto = alturas[i]
            indice = i
    
    return atletas[indice], alturas[indice]


def calcular_media(alturas):
    soma = 0

    for altura in alturas:
        soma += altura
    
    return soma / len(alturas)


def maiores_que_media(atletas, alturas, media):
    maiores = []
    alturas_maiores = []

    for i in range(12):
        if alturas[i] > media:
            maiores.append(atletas[i])
            alturas_maiores.append(alturas[i])

    return maiores, alturas_maiores


if __name__ == "__main__":
    main()