#Solicita do usuário os valores de dividendo e divisor
dividendo = float(input().strip())
divisor = float(input().strip())

#Calcula o resultado e o resto da divisão
resultado = float(dividendo // divisor)
resto = float(dividendo % divisor)

#Mostra em tela o resultado e o resto
print(f'{resultado:.4f}')
print(f'{resto:.4f}')