def main():
    limite_1 = int(input())  # lê o primeiro número do intervalo
    limite_2 = int(input())  # lê o segundo número

    # garante que os limites estejam em ordem crescente
    limite_inf, limite_sup = ordenar(limite_1, limite_2)

    # verifica e imprime os primos dentro do intervalo
    verificar_primos(limite_inf, limite_sup)


def ordenar(num1, num2):
    # se estiver fora de ordem, troca
    if num2 < num1:
        num1, num2 = num2, num1

    return num1, num2  # retorna em ordem correta


def verificar_primos(limite1, limite2):
    for num in range(limite1, limite2 + 1):  # percorre o intervalo
        if eh_primo(num):  # se for primo, mostra
            print(num)


def eh_primo(num):
    multiplos = 0  # conta os divisores

    for c in range(1, num + 1):
        if (num % c == 0):
            multiplos += 1

    return multiplos == 2  # retorna True se for primo


if __name__ == "__main__":
    main()
