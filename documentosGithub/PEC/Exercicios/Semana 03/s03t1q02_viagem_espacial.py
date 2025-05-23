#Solicita distancia da nave ao planeta e a velocidade da nave
distancia = int(input().strip())
velocidade = int(input().strip())

#calcula o tempo total da viagem
horas = distancia / velocidade

#calcula a quantiade de dias
dias = int(horas // 24)

#calula a quantidade de horas restantes
horas = int(horas % 24)

#mostra em tela a quantidade de dias e de horas de duração da viagem
print(f'{dias} dias e {horas} horas')