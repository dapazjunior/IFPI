from random import *

print('''
Porta da Fortuna!
==========

Existe um super prêmio atrás de uma destas 3 portas! Adivinhe qual é a porta certa para ganhar o prêmio!
 _____   _____   _____
|     | |     | |     |
| [1] | | [2] | | [3] |
|   o | |   o | |   o |
|_____| |_____| |_____|
''')

jogando = True
score = 0

while jogando:
    print("\nEscolha uma porta (1, 2 ou 3):")
    
    portaEscolhida = input()
    portaEscolhida = int(portaEscolhida)
    
    portaCerta = randint(1,3)
    
    print("A porta escolhida foi a", portaEscolhida)
    print("A porta certa é a", portaCerta)
    
    if portaEscolhida == portaCerta:
        print("Parabéns!")
        score = score + 1
    else:
        print("Que peninha!")
        # Desafio: zerar a pontuação ao errar
        score = 0
    
    print("Sua pontuação atual é", score)
    
    print("\nDeseja jogar novamente? (s/n)")
    resposta = input().lower()  # Transforma em minúsculo para aceitar 'N' ou 'n'
    
    if resposta == 'n' or resposta == 'nao' or resposta == 'não':
        jogando = False

print("\nJogo encerrado. Sua pontuação final foi", score)