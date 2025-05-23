def main():
    """Lê um número, verifica a soma dos algarismos e exibe o resultado."""

    #Entrada de dados
    num = int(input())

    #Processamento
    soma = verificar_soma(num)

    #Saída de dados
    print(soma)


def separar_e_somar_algarismos(n):
    """Recebe um número de até 6 dígitos e retorna a soma dos seus algarismos."""

    cm = n // 100000
    dm = (n % 100000) // 10000
    um = ((n % 100000) % 10000) // 1000
    c = (((n % 100000) % 10000) % 1000) // 100
    d = ((((n % 100000) % 10000) % 1000) % 100) // 10
    u = ((((n % 100000) % 10000) % 1000) % 100) % 10

    return cm + dm + um + c + d + u


def verificar_soma(n):
    """Verifica se 'n' está entre 0 e 100000 e retorna a soma dos algarismos. Caso contrário, retorna -1."""
    
    if 0 <= n <= 100000:
        soma = separar_e_somar_algarismos(n)
    else:
        soma = -1

    return soma


if __name__ == "__main__":
    main() 