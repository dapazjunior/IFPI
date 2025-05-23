#Solicita do usuário a quantidade de anos trabalhados e o valor do bônus anual
anos = int(input().strip())
bonus_anual = float(input().strip())

#Calcula o valor total do bônus
bonus = bonus_anual * anos

#Mostra em tela o valor do bônus
print(f'{bonus:.2f}')