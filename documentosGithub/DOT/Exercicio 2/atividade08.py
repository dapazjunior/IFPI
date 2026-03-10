import random
import string

def main():
    qtd_letras = 10

    lista_letras = gerar_letras(qtd_letras)

    total_a = contar_letra_a(lista_letras)

    print("Lista gerada:", lista_letras)
    print("Quantidade de letras 'A':", total_a)


def gerar_letras(quantidade):
    letras = random.choices(string.ascii_letters, k=quantidade)
    return letras


def contar_letra_a(lista):
    contador = 0

    for letra in lista:
        if letra.lower() == 'a':
            contador += 1

    return contador


main()