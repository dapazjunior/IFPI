from turtle import *
from random import randint, random
import math

# Configurações iniciais
speed(0)  # Velocidade máxima
bgcolor("black")  # Fundo preto
hideturtle()  # Esconde o cursor

# Função para gerar cores aleatórias em hexadecimal
def cor_aleatoria():
    r = random()
    g = random()
    b = random()
    return "#{:02X}{:02X}{:02X}".format(int(r*255), int(g*255), int(b*255))


# Função para mover para posição aleatória
def mover_aleatorio():
    penup()
    goto(randint(-300, 300), randint(-300, 300))
    setheading(randint(0, 359))
    pendown()


# Função para quadrado
def quadrado(tamanho):
    begin_fill()
    for _ in range(4):
        forward(tamanho)
        right(90)
    end_fill()


# Função para triângulo
def triangulo(tamanho):
    begin_fill()
    for _ in range(3):
        forward(tamanho)
        left(120)
    end_fill()


# Função para pentágono
def pentagono(tamanho):
    begin_fill()
    for _ in range(5):
        forward(tamanho)
        left(72)
    end_fill()


# Função para estrela
def estrela(tamanho):
    begin_fill()
    for _ in range(5):
        forward(tamanho)
        right(144)  # Ângulo fixo para 5 pontas
    end_fill()


# Desenha 50 formas aleatórias
for i in range(50):
    # Escolhe uma forma aleatória sem usar lista
    forma_num = randint(1, 4)
    tamanho = randint(20, 80)
    cor = cor_aleatoria()
    color(cor)
    
    mover_aleatorio()
    
    if forma_num == 1:
        quadrado(tamanho)
    elif forma_num == 2:
        triangulo(tamanho)
    elif forma_num == 3:
        pentagono(tamanho)
    else:
        estrela(tamanho, randint(5, 8))

done()