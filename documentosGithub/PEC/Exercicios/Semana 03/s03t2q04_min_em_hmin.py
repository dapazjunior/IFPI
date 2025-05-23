#Solicita ao usuário a quantidade de minutos
minutos = int(input().strip())

#Converte os minutos totais em horas e minutos
horas = minutos // 60
minutos = minutos % 60

#Mostra em tela os valores em Horas e Minutos
print(f'{horas}h{minutos}min')