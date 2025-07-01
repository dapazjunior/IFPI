from turtle import *
from random import randint

# Configurações básicas
speed(0)
bgcolor("black")
hideturtle()

# Função para escolher uma cor
def escolher_cor():
    cor_num = randint(1, 8)  # Gera número de 1 a 8
    if cor_num == 1:
        return "#FF0000"  # Vermelho
    elif cor_num == 2:
        return "#00FF00"  # Verde
    elif cor_num == 3:
        return "#0000FF"  # Azul
    elif cor_num == 4:
        return "#FFFF00"  # Amarelo
    elif cor_num == 5:
        return "#FF00FF"  # Magenta
    elif cor_num == 6:
        return "#00FFFF"  # Ciano
    elif cor_num == 7:
        return "#FFA500"  # Laranja
    else:
        return "#800080"  # Roxo


# Funções das formas
def quadrado(tam):
    begin_fill()
    for _ in range(4):
        forward(tam)
        right(90)
    end_fill()


def triangulo(tam):
    begin_fill()
    for _ in range(3):
        forward(tam)
        left(120)
    end_fill()


def pentagono(tam):
    begin_fill()
    for _ in range(5):
        forward(tam)
        left(72)
    end_fill()


def estrela(tam):
    begin_fill()
    for _ in range(5):
        forward(tam)
        right(144)
    end_fill()


# Desenha 50 formas
for _ in range(50):
    # Escolhe forma (1=quadrado, 2=triangulo, 3=pentagono, 4=estrela)
    forma = randint(1, 4)
    tam = randint(20, 80)
    
    # Posiciona
    penup()
    goto(randint(-300, 300), randint(-300, 300))
    setheading(randint(0, 359))
    pendown()
    
    # Aplica cor e desenha
    color(escolher_cor())
    
    if forma == 1:
        quadrado(tam)
    elif forma == 2:
        triangulo(tam)
    elif forma == 3:
        pentagono(tam)
    else:
        estrela(tam)

done()