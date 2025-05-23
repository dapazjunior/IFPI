altura = float(input().strip())
comprimento = float(input().strip())
largura = float(input().strip())

area_piso = comprimento * largura
volume_sala = altura * comprimento * largura
area_paredes = 2 * altura * (largura + comprimento)

print(area_piso)
print(volume_sala)
print(area_paredes)