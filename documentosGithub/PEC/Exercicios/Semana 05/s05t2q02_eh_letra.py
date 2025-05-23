def main():
    caractere = input().strip()

    print(eh_letra(caractere))

def eh_letra(caractere):
    # A função 'ord(caractere)' informa o código da tabela ASCII do caractere digitado.
    codigo = ord(caractere)

    #As letras maiúsculas são os códigos 65 a 90 de ASCII, as minusculas os 97 a 122.
    return((65 <= codigo <= 90) or (97 <= codigo <= 122) or ord == 231 or ord == 199)

main()