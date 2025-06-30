def main():
    preco_carro = float(input())  # valor do carro usado

    tempo = calcular_tempo(preco_carro)

    print(tempo)


def atualizar_valor(valor_inicial, taxa, tempo):
    # fórmula de juros compostos: valor * (1 + taxa) ^ tempo
    return valor_inicial * (1 + taxa) ** tempo


def calcular_tempo(preco):
    tempo = 0
    # enquanto o usado valer mais que o novo
    while atualizar_valor(preco, 0.004, tempo) > atualizar_valor(10000, 0.007, tempo):
        tempo += 1

    return tempo


if __name__ == "__main__":
    main()
