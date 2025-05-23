def main():
    caractere = input().strip()

    print(eh_vogal(caractere))

def eh_vogal(letra):
    #Para facilitar, transformaremos as letras para minusculas
    letra = letra.lower()
    return (letra == "a" or letra == "e" or letra == "i" or letra == "o" or letra == "u")

main()