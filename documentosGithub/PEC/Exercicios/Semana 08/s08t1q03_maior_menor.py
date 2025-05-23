def main():
    """Lê 5 números, calcula e exibe o maior e o menor."""

    #Entrada de dados
    num1 = int(input())
    num2 = int(input())
    num3 = int(input())
    num4 = int(input())
    num5 = int(input())
    
    #Processamento
    maior = verificar_maior(num1, num2, num3, num4, num5)
    menor = verificar_menor(num1, num2, num3, num4, num5)
    
    #Saída de dados
    print(f'{maior}')
    print(f'{menor}')


def verificar_maior(a, b, c, d, e):
    """Recebe 5 números. Retorna o maior número."""

    maior = a
    maior = eh_maior(b, maior)
    maior = eh_maior(c, maior)
    maior = eh_maior(d, maior)
    maior = eh_maior(e, maior)

    return maior


def verificar_menor(a, b, c, d, e):
    """Recebe 5 números. Retorna o menor número."""

    menor = a
    menor = eh_menor(b, menor)
    menor = eh_menor(c, menor)
    menor = eh_menor(d, menor)
    menor = eh_menor(e, menor)

    return menor


def eh_maior(n, maior):
    """Retorna o maior entre n e maior."""

    if n > maior:
        return n
    else:
        return maior


def eh_menor(n, menor):
    """Retorna o menor entre n e menor."""

    if n < menor:
        return n
    else:
        return menor


if __name__ == "__main__":
    main()