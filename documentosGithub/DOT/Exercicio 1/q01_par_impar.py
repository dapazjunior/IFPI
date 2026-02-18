def main():
    num = int(input("Digite um número:\n>>> "))
    verificar = verificar_se_par(num)
    
    if verificar:
        print(f"O número {num} é par.")
    else:
        print(f"O número {num} é ímpar.")


def verificar_se_par(num):
    return num % 2 == 0


if __name__ == "__main__":
    main()