#Solicita a quantidade de doces e de pacotes
doces = int(input().strip())
pacotes = int(input().strip())

#divide igualmente um numero inteiro de doces por pacote
doces_por_pacote = int(doces // pacotes)

#mostra a quantidade de doces por pacote
print(doces_por_pacote)