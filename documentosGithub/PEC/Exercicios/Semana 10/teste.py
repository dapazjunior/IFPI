numeros = [3, 7, 10, 15, 20]
alvo = int(input("Digite um número para procurar: "))

encontrado = False  # flag para saber se achou

for num in numeros:
    if num == alvo:
        print(f"O número {alvo} está na lista!")
        encontrado = True
        break

if not encontrado:
    print(f"O número {alvo} não está na lista.")