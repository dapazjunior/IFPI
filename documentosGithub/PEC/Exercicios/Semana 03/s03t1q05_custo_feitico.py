#Solicita a quantidade dos ingredientes
po_de_lua = int(input().strip())
essencia_dragao = int(input().strip())
lagrimas_fenix = int(input().strip())

#Pó de lua custa $5, Essência de Dragão custa $3 e Lágrima de fênix custa $8.

#Calcula o custo total
total = po_de_lua * 5 + essencia_dragao * 3 + lagrimas_fenix * 8

#Mostra em tela o custo total
print(total)