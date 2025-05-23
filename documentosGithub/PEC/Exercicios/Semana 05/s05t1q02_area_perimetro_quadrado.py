def main():
    lado = float(input())
    
    area = area_quadrado(lado)
    perimetro = perimetro_quadrado(lado)

    print(f"{area:10.4f}")
    print(f"{perimetro:10.4f}")

def area_quadrado(lado):
    area = lado ** 2
    return area

def perimetro_quadrado(lado):
    perimetro = lado * 4
    return perimetro

main()