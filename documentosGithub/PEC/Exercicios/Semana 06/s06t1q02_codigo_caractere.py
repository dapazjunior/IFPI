def main():
    """Lê um caractere digitado pelo usuário, remove espaços nas bordas 
    e exibe o código numérico correspondente na tabela Unicode"""
    caractere = input()

    codigo = obter_codigo (caractere)

    print(codigo)


def obter_codigo (caractere):
    """Retorna o valor numérico Unicode do caractere recebido"""

    codigo = ord(caractere)
    return codigo

if __name__ == "__main__":
    main()