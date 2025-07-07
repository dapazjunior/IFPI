# Alfabeto para criptografia
alfabeto = "abcdefghijklmnopqrstuvwxyz"

# Captura a mensagem e converte para minúsculas
mensagem = input("Digite a mensagem para criptografar: ").lower()

# Chave secreta (convertida para inteiro)
chave = int(input("Digite a chave secreta: "))

# Variável para armazenar a mensagem criptografada
mensagemCriptografada = ""

# Loop para processar cada caractere da mensagem
for char in mensagem:
    if char in alfabeto:  # Verifica se o caractere está no alfabeto
        posicao = alfabeto.find(char)
        novaPosicao = (posicao + chave) % 26
        mensagemCriptografada += alfabeto[novaPosicao]
    else:
        # Caracteres não alfabéticos (espaços, símbolos) são mantidos
        mensagemCriptografada += char

print("Mensagem criptografada:", mensagemCriptografada)