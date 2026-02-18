def main():
    num_lados = int(input("Digite o número de lados do polígono:\n>>> "))
    medida_lado = float(input("Digite a medida do lado (em cm):\n>>> "))

    processar_poligono(num_lados, medida_lado)


def processar_poligono(lados, lado):
    if lados == 3:
        perimetro = 3 * lado
        print(f"TRIÂNGULO")
        print(f"Perímetro: {perimetro:.2f} cm")
    elif lados == 4:
        area = lado ** 2
        print(f"QUADRADO")
        print(f"Área: {area:.2f} cm²")
    elif lados == 5:
        print(f"PENTÁGONO")


if __name__ == "__main__":
    main()
