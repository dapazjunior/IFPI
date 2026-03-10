import random

def main():
    qtd_lista = 2

    lista_qtd = grava_lista(qtd_lista)
    print(lista_qtd)
    lista_preco = grava_lista(qtd_lista)
    print(lista_preco)

    faturamento = calcaular_faturamento(lista_qtd, lista_preco)

    print(f'O faturamento é R$ {faturamento:.2f}')
      

def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(round((random.uniform(1, 300)), 2))
    
    return lista


def calcaular_faturamento(quantidade, preco):
    faturamento = 0

    for i in range(len(quantidade)):
        faturamento += (quantidade[i] * preco[i])
    
    return faturamento


if __name__ == "__main__":
    main()