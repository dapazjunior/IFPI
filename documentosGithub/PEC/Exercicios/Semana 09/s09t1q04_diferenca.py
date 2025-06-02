def main():
    """Lê três valores e exibe a menor diferença absoluta entre o primeiro e os outros dois."""
    # Entrada de dados
    valor1 = int(input())
    valor2 = int(input())
    valor3 = int(input())

    # Processamento e saída de dados
    print(verificar_diferenca(valor1, valor2, valor3))


def verificar_diferenca(v1, v2, v3):
    """Retorna a menor diferença absoluta entre v1 e v2 ou v1 e v3."""
    if abs(subtracao(v1, v2)) <= abs(subtracao(v1, v3)):
        return abs(subtracao(v1, v2))
    else:
        return abs(subtracao(v1, v3))


def subtracao(v1, v2):
    """Retorna a subtração de v1 por v2."""
    return v1 - v2


if __name__ == "__main__":
    main()
