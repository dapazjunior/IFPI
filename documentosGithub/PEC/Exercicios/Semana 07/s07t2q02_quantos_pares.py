def main():
    """Recebe um número de 3 dígitos e conta quantos dos 3 dígitos são pares"""

    #Entrada de dados
    num = int(input())

    #Processamento
    c, d, u = separar_algarismos(num)
    pares = contar_pares(c, d, u)

    #Saída de dados
    print(pares)


def separar_algarismos(numero):
    """Separa e retorna o algarismo da centena, dezena e unidade."""

    c = numero // 100
    d = (numero % 100) // 10
    u = (numero % 100) % 10

    return c, d, u


def contar_pares(num1, num2, num3):
    """Conta e retorna quantos números entres os 3 informados são pares"""

    pares = 0
    
    if eh_par(num1):
        pares += 1
        if num1 == 0:
            pares = 0
    if eh_par(num2):
        pares += 1
    if eh_par(num3):
        pares += 1
    
    return pares


def eh_par(numero):
    """Retorna True se o valor for par, caso contrário False."""

    return numero % 2 == 0


if __name__ == "__main__":
    main()