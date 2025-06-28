def main():
    limite_1 = int(input())
    limite_2 = int(input())

    limite_inf, limite_sup = ordenar(limite_1, limite_2)

    verificar_primos(limite_inf, limite_sup)


def eh_primo(num):
    multiplos = 0
    
    for c in range(1, num + 1):
        if (num % c == 0):
            multiplos +=  1
    
    return multiplos == 2


def verificar_primos(limite1, limite2):
    for num in range(limite1, limite2 + 1):
        if eh_primo(num):
            print(num)


def ordenar(num1, num2):
    aux = num1
    
    if num2 < num1:
        num1 = num2
        num2 = aux
    
    return num1, num2


if __name__ == "__main__":
    main()