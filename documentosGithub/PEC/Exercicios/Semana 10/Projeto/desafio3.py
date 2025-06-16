from turtle import *

def main():
    lados, angulo = verificar_lados_e_angulo()
    turtle_walk(lados, angulo)


def verificar_lados_e_angulo():
    lados = int(input("Quantos lados?\n>>> "))
    angulo = 360 / lados

    return lados, angulo


def turtle_walk(lados, angulo):
    speed(11)
    shape("turtle")

    for _ in range(lados):
        forward(100)
        left(angulo)

    done()


if __name__ == "__main__":
    main()