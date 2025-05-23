#Define a constante adotada para PI
PI = 3.141592

#Solicita do usuário o valor do raio
raio = float(input().strip())

#Calcula o comprimento da circunferência
comprimento_circunferencia = 2 * PI * raio

#Calcula a área do círculo
area_circulo = PI * raio * raio

#Calcula a área da esfera
area_esfera = 4 * PI * raio * raio

#Calcula o volume da esfera
volume_esfera = (4/3) * PI * raio * raio * raio

#Mostra em tela os valores calculados
print(f'{comprimento_circunferencia:.6f}')
print(f'{area_circulo:.6f}')
print(f'{area_esfera:.6f}')
print(f'{volume_esfera:.6f}')