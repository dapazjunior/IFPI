#Solicita do usuário o preço do produto
preco = float(input().strip())

#Calcula o desconto de 10%
desconto = preco * 0.1

#Calcula o novo preço com o desconto
preco = preco - desconto

#Mostra em tela o novo preço
print(f'{preco:.2f}')