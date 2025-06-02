def main():
    """Lê dois valores e uma operação, executa e exibe o resultado."""
    # Entrada de dados
    valor1 = float(input())
    valor2 = float(input())
    operacao = int(input())

    # Processamento e saída de dados
    print(f'{verificar_operacao(valor1, valor2, operacao):.2f}')


def verificar_operacao(v1, v2, op):
    """Executa soma, subtração, multiplicação ou divisão conforme a opção."""
    if op == 1:
        valor = adicao(v1, v2)
    elif op == 2:
        valor = subtracao(v1, v2)
    elif op == 3:
        valor = multiplicacao(v1, v2)
    elif op == 4:
        valor = divisao(v1, v2)

    return valor


def adicao(v1, v2):
    """Retorna a soma dos valores."""
    return v1 + v2


def subtracao(v1, v2):
    """Retorna a subtração dos valores."""
    return v1 - v2


def multiplicacao(v1, v2):
    """Retorna a multiplicação dos valores."""
    return v1 * v2


def divisao(v1, v2):
    """Retorna a divisão dos valores."""
    return v1 / v2


if __name__ == "__main__":
    main()
