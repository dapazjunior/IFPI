def main():
    """Lê peso e altura, calcula o IMC e exibe a situação."""

    #Entrada de dados
    peso = float(input())
    altura = float(input())

    #Processamento
    imc = calcular_imc(peso, altura)
    
    #Saída de dados
    print(f'{imc:.2f}')
    print(analisar_imc(imc))


def calcular_imc(peso, altura):
    """Recebe peso e altura. Retorna o IMC calculado."""
    
    return peso / (altura ** 2)


def analisar_imc(imc):
    """Recebe o IMC. Retorna a classificação do IMC."""

    if imc < 18.5:
        return "Abaixo do peso"
    elif imc < 25:
        return "Peso normal"
    elif imc < 30:
        return "Sobrepeso"
    elif imc < 35:
        return "Obeso leve"
    elif imc < 40:
        return "Obeso moderado"
    else:
        return "Obeso mórbido"


if __name__ == "__main__":
    main()