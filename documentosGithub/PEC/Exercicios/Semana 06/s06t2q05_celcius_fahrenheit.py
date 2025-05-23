def main():
    """Lê uma temperatura em graus Celsius e imprime o valor convertido para Fahrenheit"""

    celsius = float(input())
    fahrenheit = converter_fahrenheit(celsius)
    print(f'{fahrenheit:.2f}')

def converter_fahrenheit(celsius):
    """Converte e retorna a temperatura de Celsius para Fahrenheit"""

    fahrenheit = (celsius * (9 / 5)) + 32
    return fahrenheit

if __name__ == "__main__":
    main()
