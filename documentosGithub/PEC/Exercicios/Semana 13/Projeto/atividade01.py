# Lista de letras para criptografar (alfabeto)
alfabeto = "abcdefghijklmnopqrstuvwxyz"

# A chave secreta é 3 (deslocamento da cifra de César)
chave = 3

# Solicita ao usuário uma letra para criptografar
letra = input("Por favor, entre com uma letra para criptografar: ").lower()

# Encontra a posição da letra em alfabeto
# Exemplo: 'a' está na posição 0, 'e' na posição 4, etc.
posicao = alfabeto.find(letra)

# Soma a chave secreta para encontrar a posição da letra criptografada
# % 26 significa "volte para 0 quando chegar em 26" (para lidar com 'z' → 'a')
novaPosicao = (posicao + chave) % 26

# A letra criptografada está no alfabeto na nova posição
letraCriptografada = alfabeto[novaPosicao]

print("Sua letra criptografada é", letraCriptografada)