def main():
    frase = input()
    num_caracteres = contar_caracteres(frase)

    print(num_caracteres)

def contar_caracteres(string):
    """Conta e retorna a quantidade de caracteres de uma string, 
    desconsiderando os espaços em branco no início e no fim"""
    
    string = string.strip()
    tamanho = len(string)
    return tamanho


if __name__ == "__main__":
    main()