def main():
    temperatura1 = receber_temperatura()
    temperatura2 = receber_temperatura()


    maior = verificar_maior(temperatura1, temperatura2)

    print(maior)


def receber_temperatura():
    temperatura = float(input())
    escala = input().strip().upper()[0]
    temp = temperatura, escala
    return temp


def celsius_para_fahrenheit(celsius):
    return (celsius * 9 / 5) + 32


def verificar_maior(t1, t2):
    maior = t1

    if t1[1] == "C":
        taux1 = celsius_para_fahrenheit(t1[0])
    else:
        taux1 = t1[0]
    
    if t2[1] == "C":
        taux2 = celsius_para_fahrenheit(t2[0])
    else:
        taux2 = t2[0]
    
    if taux2 > taux1:
        maior = t2
    
    return maior


if __name__ == "__main__":
    main()