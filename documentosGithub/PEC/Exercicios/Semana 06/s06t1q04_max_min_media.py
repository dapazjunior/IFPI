def main():
    """Lê cinco números inteiros do usuário, calcula e exibe o maior valor, 
    o menor valor e a média entre eles"""

    n1 = int(input())
    n2 = int(input())
    n3 = int(input())
    n4 = int(input())
    n5 = int(input())

    maior = verificar_maior(n1, n2, n3, n4, n5)
    menor = verificar_menor(n1, n2, n3, n4, n5)
    media = verificar_media(n1, n2, n3, n4, n5)

    print(maior)
    print(menor)
    print(media)

def verificar_maior(n1, n2, n3, n4, n5):
    """Retorna o maior valor entre cinco números inteiros"""

    maior = max(n1, n2, n3, n4, n5)
    return maior


def verificar_menor(n1, n2, n3, n4, n5):
    """Retorna o menor valor entre cinco números inteiros"""

    menor = min(n1, n2, n3, n4, n5)
    return menor

def verificar_media(n1, n2, n3, n4, n5):
    """Calcula e retorna a média aritmética entre cinco números inteiros"""
    
    media =(n1 + n2 + n3 + n4 + n5)/5
    return media

if __name__ == "__main__":
    main()