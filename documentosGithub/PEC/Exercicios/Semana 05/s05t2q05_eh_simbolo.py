def main():
    caractere = input().strip()

    print(eh_simbolo(caractere))

def eh_letra(caractere):
    # A função 'ord(caractere)' informa o código da tabela ASCII do caractere digitado.
    codigo = ord(caractere)

    #As letras maiúsculas são os códigos 65 a 90 de ASCII, as minusculas os 97 a 122.
    return((65 <= codigo <= 90) or (97 <= codigo <= 122))

def eh_numero(caractere):
    codigo = ord(caractere)

    #Os números são os códigos 48 a 57 de ASCII.
    return(48 <= codigo <= 57)

def eh_simbolo(caractere):
    return(not(eh_letra(caractere) or eh_numero(caractere)))

main()