from turtle import *

# Função para desenhar planetas com tamanho e cor customizáveis
def drawPlanet(planetSize, planetColor):
    color(planetColor)          # Define a cor do planeta
    pendown()
    begin_fill()
    circle(planetSize)          # Desenha o círculo com o tamanho especificado
    end_fill()
    penup()

# Exemplo de uso:
bgcolor("MidnightBlue")        # Fundo espacial

# Desenha planetas em posições diferentes
drawPlanet(80, "#FF5733")      # Planeta vermelho
forward(150)
drawPlanet(40, "#33A1FF")      # Planeta azul
left(120)
forward(200)
drawPlanet(60, "#32CD32")      # Planeta verde

hideturtle()
done()