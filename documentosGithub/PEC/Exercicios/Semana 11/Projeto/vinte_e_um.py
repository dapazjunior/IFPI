from random import *

print('''
Vinte e um!
==========
Tente fazer exatamente 21 pontos!
''')

jogando = True
pontuacao = 0

while jogando and pontuacao < 21:
    numero = randint(1, 10)
    pontuacao = pontuacao + numero
    
    print("\nSeu próximo número é", numero)
    print("Sua pontuação agora é", pontuacao)
    
    if pontuacao >= 21:
        break
    
    print("\nGostaria de somar mais um número? (s/n)")
    resposta = input().lower()
    
    if resposta == 'n' or resposta == 'nao' or resposta == 'não':
        jogando = False

if pontuacao == 21:
    print("\nSua pontuação final é 21")
    print("VOCÊ VENCEU!!!")
else:
    print("\nSua pontuação final é", pontuacao)
    print("Que pena!!")