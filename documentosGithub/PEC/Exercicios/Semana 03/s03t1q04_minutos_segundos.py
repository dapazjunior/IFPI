#Solicita a quatidade de segundos
segundos = int(input().strip())

#calcula o numero de minutos
minutos = segundos // 60

#calcula a quantiade de segundos restantes
segundos = segundos % 60 

#mostra em tela a quantidade de minutos e segundos
print(minutos)
print(segundos)