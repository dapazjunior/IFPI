def main():
    n1 = float(input("Digite a nota 1:\n>>> "))
    n2 = float(input("Digite a nota 2:\n>>> "))

    media = calcular_media(n1, n2)

    print(f"Sua média foi: {media:.1f}!")

    if media >= 6:
        print("PARABÉNS! Você foi aprovado!")


def calcular_media(a, b):
    return (a + b) / 2


if __name__=="__main__":
    main()