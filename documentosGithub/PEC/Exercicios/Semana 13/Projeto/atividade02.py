# Lista de letras para descriptografar
alfabeto = "abcdefghijklmnopqrstuvwxyz"

# Usando -3 para descriptografar (movimento inverso)
chave = -3

letra = input("Por favor, entre com uma letra para descriptografar: ").lower()

# Mesma lógica da criptografia, mas com chave negativa
posicao = alfabeto.find(letra)
novaPosicao = (posicao + chave) % 26
letraDescriptografada = alfabeto[novaPosicao]

print("Sua letra descriptografada é", letraDescriptografada)