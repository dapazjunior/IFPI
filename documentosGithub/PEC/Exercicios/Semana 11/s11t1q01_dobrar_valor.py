def main():
    deposito = float(input())  # valor que foi depositado
    taxa = float(input())      # taxa de juros ao mês

    tempo = verificar_se_dobrou(deposito, taxa)  # calcula em quantos meses o valor dobra

    print(tempo)


def calcular_acumulado(valor, juros, tempo):
    # fórmula de juros compostos
    acumulado = valor * ((1 + juros/100) ** tempo) 
    return acumulado


def verificar_se_dobrou(valor, juros):
    acumulado = valor
    tempo = 0

    # vai repetindo até o valor dobrar
    while acumulado <= 2 * valor:
        tempo += 1
        acumulado = calcular_acumulado(valor, juros, tempo)
    
    return tempo


if __name__ == "__main__":
    main()
