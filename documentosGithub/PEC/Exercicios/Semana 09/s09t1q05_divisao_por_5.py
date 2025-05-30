def main():
    valor = int(input())

    print(verificar_valores(valor))


def verificar_valores(num):
    valor = num % 5

    if valor == 0:
        return 9 * num + 7
    elif valor == 2:
        return (5 * num ** 2 - 3 * num + 42)
    elif valor == 3:
        return num // 10
    elif valor == 4:
        return num ** 2
    else:
        return "par" if eh_par(num) else "ímpar"
    

def eh_par(num):
    return num % 2 == 0

if __name__ == "__main__":
    main()