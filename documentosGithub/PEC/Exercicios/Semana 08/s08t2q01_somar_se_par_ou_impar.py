def main():
    """Lê um número, soma 5 se for par ou 8 se for ímpar, e exibe o resultado."""

    #Entrada de dados
    num = int(input())
    soma = num
    
    #Processamento
    if eh_par(num):
        soma += 5
    elif eh_impar(num):
        soma += 8

    #Saída de dados
    print(soma)


def eh_par(numero):
    """Retorna True se o valor for par, caso contrário False."""

    return numero % 2 == 0


def eh_impar(valor):
    """Retorna True se o valor for ímpar, caso contrário False."""
    return (valor % 2) != 0 


if __name__ == "__main__":
    main()