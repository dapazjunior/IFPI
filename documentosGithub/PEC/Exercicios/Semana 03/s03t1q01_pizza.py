fatias = int(input().strip())
amigos = int(input().strip())

fatias_cada = fatias // amigos
sobra = fatias % amigos

print(fatias_cada)
print(sobra)