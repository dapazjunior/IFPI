def main():
    temperatura1 = receber_temperatura()  # lê a primeira temperatura
    temperatura2 = receber_temperatura()  # lê a segunda temperatura

    soma = somar_temperaturas(temperatura1, temperatura2)  # faz a soma

    print(soma)  # exibe a tupla com resultado


def receber_temperatura():
    temperatura = float(input())  # lê o valor da temperatura
    escala = input().strip().upper()[0]  # pega a escala, usa só a primeira letra
    temp = temperatura, escala  # monta a tupla (valor, escala)
    return temp


def celsius_para_fahrenheit(celsius):
    # converte Celsius para Fahrenheit
    return (celsius * 9 / 5) + 32


def fahrenheit_para_celsius(fahrenheit):
    # converte Fahrenheit para Celsius
    return (fahrenheit - 32) * 5 / 9


def somar_temperaturas(t1, t2):
    if t1[1] == t2[1]:
        # se as escalas forem iguais, soma direto
        tsoma = t1[0] + t2[0]
    
    else:
        # se forem diferentes, converte t1 para a escala da t2
        if t2[1] == 'C':
            tsoma = fahrenheit_para_celsius(t1[0]) + t2[0]
        else:
            tsoma = celsius_para_fahrenheit(t1[0]) + t2[0]

    return (round(tsoma, 4), t2[1])  # retorna o valor somado e a escala da segunda


if __name__ == "__main__":
    main()
