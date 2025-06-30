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
pontuacao = 0

while jogando:
    print("\nEscolha uma porta (1, 2 ou 3):")
    
    portaEscolhida = input()
    portaEscolhida = int(portaEscolhida)
    
    portaCerta = randint(1,3)
    
    print("A porta escolhida foi a", portaEscolhida)
    print("A porta certa é a", portaCerta)
    
    if portaEscolhida == portaCerta:
        print("Parabéns!")
        pontuacao += 1
    else:
        print("Que peninha!")
    
    print("\nDeseja jogar novamente? (s/n)")
    resposta = input()
    
    if resposta == 'n':
        jogando = False

print("Obrigado por jogar.")
print("Sua pontuação final foi", pontuacao)