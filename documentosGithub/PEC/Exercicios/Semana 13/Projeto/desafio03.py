print("Calculadora do Amor <3")

# Captura os nomes e converte para minúsculas
nome1 = input("Digite o primeiro nome: ").lower()
nome2 = input("Digite o segundo nome: ").lower()

placar = 0  # Inicializa o placar de compatibilidade

# Loop para cada caractere nos dois nomes combinados
for char in nome1 + nome2:
    # Concede 5 pontos se o caractere for uma vogal
    if char in "aeiou":
        placar += 5
    # Concede 10 pontos se o caractere estiver em "amor"
    if char in "amor":
        placar += 10

# Exibe mensagens personalizadas com base no placar
if placar > 70:
    print(f"Placar: {placar}. Vocês são almas gêmeas! <3")
elif placar > 30:
    print(f"Placar: {placar}. Boa compatibilidade!")
else:
    print(f"Placar: {placar}. Hmm... talvez não seja a melhor combinação.")