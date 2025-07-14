def main():
    temperatura1 = receber_temperatura()  # lê a primeira temperatura
    temperatura2 = receber_temperatura()  # lê a segunda temperatura

    maior = verificar_maior(temperatura1, temperatura2)  # compara as duas

    print(maior)  # exibe a temperatura mais alta


def receber_temperatura():
    temperatura = float(input())  # lê o valor da temperatura
    escala = input().strip().upper()[0]  # lê a escala (C ou F), usando apenas a primeira letra
    temp = temperatura, escala  # monta a tupla
    return temp


def celsius_para_fahrenheit(celsius):
    # fórmula para converter Celsius para Fahrenheit
    return (celsius * 9 / 5) + 32


def verificar_maior(t1, t2):
    maior = t1  # começa assumindo que a primeira é maior

    # se a primeira temperatura for Celsius, converte pra Fahrenheit
    if t1[1] == "C":
        taux1 = celsius_para_fahrenheit(t1[0])
    else:
        taux1 = t1[0]
    
    # se a segunda temperatura for Celsius, também converte
    if t2[1] == "C":
        taux2 = celsius_para_fahrenheit(t2[0])
    else:
        taux2 = t2[0]
    
    # compara as duas já convertidas
    if taux2 > taux1:
        maior = t2  # troca se a segunda for maior
    
    return maior  # retorna a temperatura mais alta


if __name__ == "__main__":
    main()
