def main():
    caractere = input().strip()

    print(eh_letra(caractere) and not eh_vogal(caractere))

def eh_letra(caractere):
    # A função 'ord(caractere)' informa o código da tabela ASCII do caractere digitado.
    codigo = ord(caractere)

    #As letras maiúsculas são os códigos 65 a 90 de ASCII, as minusculas os 97 a 122.
    return((65 <= codigo <= 90) or (97 <= codigo <= 122))

def eh_vogal(letra):
    #Para facilitar, transformaremos as letras para minusculas
    letra = letra.lower()
    return (letra == "a" or letra == "e" or letra == "i" or letra == "o" or letra == "u")

main()