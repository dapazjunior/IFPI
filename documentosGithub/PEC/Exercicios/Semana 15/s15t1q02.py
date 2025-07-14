def main():
    temperatura1 = receber_temperatura()
    temperatura2 = receber_temperatura()


    soma = somar_temperaturas(temperatura1, temperatura2)

    print(soma)


def receber_temperatura():
    temperatura = float(input())
    escala = input().strip().upper()[0]
    temp = temperatura, escala
    return temp


def celsius_para_fahrenheit(celsius):
    return (celsius * 9 / 5) + 32


def fahrenheit_para_celsius(fahrenheit):
    return (fahrenheit - 32) * 5 / 9


def somar_temperaturas(t1, t2):
    if t1[1] == t2[1]:
        tsoma = t1[0] + t2[0]
    
    else:
        if t2[1] == 'C':
            tsoma = fahrenheit_para_celsius(t1[0]) + t2[0]
        else:
            tsoma = celsius_para_fahrenheit(t1[0]) + t2[0]

    return (round(tsoma, 4), t2[1])


if __name__ == "__main__":
    main()