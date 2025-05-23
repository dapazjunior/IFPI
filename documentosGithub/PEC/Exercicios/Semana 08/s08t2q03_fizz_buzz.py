def main():
    """Lê um número, verifica FizzBuzz e exibe o resultado."""

    #Entrada
    num = int(input())

    #Processamento e Saída de dados
    print(verificar_fizz_buzz(num))


def verificar_fizz_buzz(n):
    """Recebe um número e retorna:
    - 'FIZZBUZZ' se for divisível por 3 e 5
    - 'FIZZ' se for divisível por 3
    - 'BUZZ' se for divisível por 5
    - O próprio número caso contrário"""

    if divisivel_por_3(n) and divisivel_por_5(n):
        return "FIZZBUZZ"
    elif divisivel_por_3(n):
        return "FIZZ"
    elif divisivel_por_5(n):
        return "BUZZ"
    else:
        return n


def divisivel_por_3(n):
    """Retorna True se 'n' for divisível por 3, senão False."""

    return n % 3 == 0


def divisivel_por_5(n):
    """Retorna True se 'n' for divisível por 5, senão False."""
    
    return n % 5 == 0


if __name__ == "__main__":
    main()