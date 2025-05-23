def main():
    """Lê uma palavra digitada pelo usuário, e imprime a quantidade de caracteres 
    da palavra"""
    palavra = input().strip()

    num = contar_caracteres (palavra)

    print(num)


def contar_caracteres (string):
    """Calcula e retorna a quantidade de caracteres presentes na string recebida"""
    n = len(string)
    return n

if __name__ == "__main__":
    main()