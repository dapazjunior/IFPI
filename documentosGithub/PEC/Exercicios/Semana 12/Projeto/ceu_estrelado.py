from turtle import *
from random import randint, choice

# --- Funções da Etapa 3 ---
def moveToRandomLocation():
    """Move a tartaruga para posição aleatória (como na p.10)"""
    penup()
    setpos(randint(-400, 400), randint(-400, 400))
    pendown()

def drawStar(starSize, starColour):
    """Desenha uma estrela (p.9)"""
    color(starColour)
    pendown()
    begin_fill()
    for _ in range(5):
        left(144)
        forward(starSize)
    end_fill()
    penup()

# --- Configurações do documento (p.11) ---
speed(11)  # Velocidade máxima
bgcolor("MidnightBlue")  # Fundo azul escuro

# --- Desenho das 30 estrelas (p.11) ---
for _ in range(30):
    moveToRandomLocation()
    drawStar(randint(5, 25), "White")  # Tamanho entre 5-25 pixels

# --- Elementos OBRIGATÓRIOS do documento ---
hideturtle()  # Esconde a tartaruga (p.11)
done()        # Finaliza o desenho