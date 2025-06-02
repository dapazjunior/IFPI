def main():
    """Lê dois lados e verifica se formam um quadrado ou calcula área e perímetro."""
    # Entrada de dados
    lado1 = int(input())
    lado2 = int(input())

    # Processamento e saída de dados
    print(verificar_poligono(lado1, lado2))


def verificar_poligono(v1, v2):
    """Verifica se os lados formam um quadrado ou calcula área e perímetro."""
    if v1 == v2:
        return "QUADRADO" 
    else:
        return f"{calcular_perimetro(v1, v2)}" + " - " + f"{calcular_area(v1, v2)}"


def calcular_perimetro(v1, v2):
    """Calcula o perímetro do retângulo."""
    return (v1 + v2) * 2


def calcular_area(v1, v2):
    """Calcula a área do retângulo."""
    return v1 * v2


if __name__ == "__main__":
    main()
