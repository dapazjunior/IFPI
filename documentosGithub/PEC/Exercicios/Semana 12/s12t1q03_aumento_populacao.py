def main():
    populacao_A = int(input())
    populacao_B = int(input())

    populacao_A, populacao_B = verificar_maior(populacao_A, populacao_B)

    tempo = calcular_tempo(populacao_A, populacao_B)

    print(tempo)


def verificar_maior(populacao1, populacao2):
    aux = populacao2

    if populacao1 < populacao2:
        populacao2 = populacao1
        populacao1 = aux
    
    return populacao1, populacao2


def atualizar_populacao(populacao_inicial, taxa, tempo):
    return ((populacao_inicial) * (1 + taxa)**tempo)


def calcular_tempo(populacao1, populacao2):
    tempo = 0
    while atualizar_populacao(populacao1, 0.02, tempo) >= atualizar_populacao(populacao2, 0.03, tempo):
        tempo += 1

    return tempo


if __name__ == "__main__":
    main()