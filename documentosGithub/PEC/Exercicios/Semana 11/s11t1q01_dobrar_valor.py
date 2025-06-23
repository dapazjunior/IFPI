def main():
    deposito = float(input())
    taxa = float(input())

    tempo = verificar_se_dobrou(deposito, taxa)

    print(tempo)


def calcular_acumulado(valor, juros, tempo):
    acumulado = valor * ((1 + juros/100) ** tempo) 
    return acumulado


def verificar_se_dobrou(valor, juros):
    acumulado = valor
    tempo = 0

    while acumulado <= 2*valor:
        tempo += 1
        acumulado = calcular_acumulado(valor, juros, tempo)
    
    return tempo


if __name__ == "__main__":
    main()