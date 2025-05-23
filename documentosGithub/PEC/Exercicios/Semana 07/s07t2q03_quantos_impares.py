def main():
    """Lê um número de dois dígitos e informa quantos dígitos são ímpares."""

    #Entrada de dados
    num = int(input())

    #Processamento
    d, u = separar_algarismos(num)
    impares = contar_impares(d, u)
    resultado = verificar_impares(impares)

    #Saída de dados
    print(resultado)


def separar_algarismos(numero):
    """Separa e retorna dezena e unidade de um número de dois dígitos."""

    d = numero // 10
    u = numero % 10

    return d, u


def contar_impares(num1, num2):
    """Conta quantos dos dois valores recebidos são ímpares."""
    impares = 0
    
    if eh_impar(num1):
        impares += 1
    if eh_impar(num2):
        impares += 1
    
    return impares


def eh_impar(numero):
    """Retorna True se o valor for ímpar, caso contrário False."""

    return numero % 2 != 0


def verificar_impares(valor):
    """Retorna a mensagem correta conforme a quantidade de dígitos ímpares."""

    if valor == 0:
        return "Nenhum dígito é ímpar."
    elif valor == 1:
        return "Apenas um dígito é ímpar."
    else:
        return "Os dois dígitos são ímpares."


if __name__ == "__main__":
    main()