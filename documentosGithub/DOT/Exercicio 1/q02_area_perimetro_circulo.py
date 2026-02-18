from math import pi
PI = pi

def main():
    raio = float(input("Digite o valor do raio:\n>>> "))
    area = calcular_area(raio)
    perimetro = calcular_perimetro(raio)
    print(f"O círculo de raio {raio:.2f} tem área {area:.2f} e perímetro {perimetro:.2f}")


def calcular_area(raio):
    return PI * (raio ** 2) 


def calcular_perimetro(raio):
    return 2 * PI * raio


if __name__=="__main__":
    main()