def main():
    inicio_tartaruga = int(input())  # onde a tartaruga começa

    tempo_alcance = calcular_tempo(inicio_tartaruga)  # calcula em quanto tempo a lebre alcança

    print(tempo_alcance)


def distancia_percorrida(velocidade, tempo, posicao_inicial=0):
    # fórmula da distância: s = s0 + v * t
    return posicao_inicial + velocidade * tempo


def calcular_tempo(inicio):
    tempo = 0
    # enquanto a tartaruga estiver na frente, continua o loop
    while distancia_percorrida(1, tempo, inicio) > distancia_percorrida(10, tempo):
        tempo += 1
    return tempo


if __name__ == "__main__":
    main()
