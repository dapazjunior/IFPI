# Lista de letras para criptografar
alfabeto = "abcdefghijklmnopqrstuvwxyz"

# Captura a chave do usuário (convertendo para inteiro)
chave = int(input("Digite a chave secreta (número inteiro): "))

letra = input("Entre com uma letra para criptografar: ").lower()

# Encontra a posição e aplica a chave personalizada
posicao = alfabeto.find(letra)
novaPosicao = (posicao + chave) % 26
letraCriptografada = alfabeto[novaPosicao]

print("Letra criptografada:", letraCriptografada)