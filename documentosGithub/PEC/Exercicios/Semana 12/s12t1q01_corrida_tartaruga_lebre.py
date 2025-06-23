def main():
    inicio_tartaruga = int(input())

    tempo_alcance = calcular_tempo(inicio_tartaruga)

    print(tempo_alcance)


def distancia_percorrida(velocidade, tempo, posicao_inicial=0):
    return (posicao_inicial + velocidade * tempo)


def calcular_tempo(inicio):
    tempo = 0
    while distancia_percorrida(1, tempo, inicio) > distancia_percorrida(10, tempo):
        tempo += 1

    return tempo


if __name__ == "__main__":
    main()