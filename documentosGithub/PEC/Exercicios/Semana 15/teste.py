def main():
    temperatura1 = receber_temperatura()
    temperatura2 = receber_temperatura()

    soma = somar_temperaturas(temperatura1, temperatura2)

    print((round(soma[0], 1), soma[1]))


def receber_temperatura():
    temperatura = float(input())
    escala = input().strip().upper()[0]
    return (temperatura, escala)


def celsius_para_fahrenheit(celsius):
    return (celsius * 9 / 5) + 32


def fahrenheit_para_celsius(fahrenheit):
    return (fahrenheit - 32) * 5 / 9


def somar_temperaturas(t1, t2):
    # Se as escalas já são iguais, soma direto
    if t1[1] == t2[1]:
        tsoma = t1[0] + t2[0]
        return (tsoma, t2[1])

    # Se a segunda temperatura está em Celsius
    if t2[1] == 'C':
        t1_convertida = fahrenheit_para_celsius(t1[0])
        tsoma = t1_convertida + t2[0]
        return (tsoma, 'C')
    else:  # Segunda temperatura está em Fahrenheit
        t1_convertida = celsius_para_fahrenheit(t1[0])
        tsoma = t1_convertida + t2[0]
        return (tsoma, 'F')


if __name__ == "__main__":
    main()
