def main():
    """Lê os preços de uma maçã e uma banana, calcula o total da compra de 3 maçãs e 2 bananas, e imprime o resultado"""
    
    #Entrada de dados
    preco_maca = float(input())
    preco_banana = float(input())

    #Processamento
    total_macas = calcular_total_macas(preco_maca)
    total_bananas = calcular_total_bananas(preco_banana)
    total = somar_dois_numeros(total_macas, total_bananas)

    #Saída de dados    
    print(f'{total:.2f}')


def calcular_total_macas(preco):
    """Calcula e retorna o valor total de 3 maçãs"""

    macas = preco * 3
    return macas


def calcular_total_bananas(preco):
    """Calcula e retorna o valor total de 2 bananas"""

    bananas = preco * 2
    return bananas


def somar_dois_numeros(num1, num2):
    """Soma e retorna dois números"""

    total = num1 + num2
    return total


if __name__ == "__main__":
    main()
