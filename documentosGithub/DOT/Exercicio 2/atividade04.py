import random

def main():
    qtd_lista = 15

    lista = grava_lista(qtd_lista)
    #print(lista)
    
    maior = max(lista)
    posicao_maior = lista.index(maior)

    menor, posicao_menor = verificar_menor(lista)

    print(f'O maior número é {maior} e está na posição {posicao_maior}')
    print(f'O menor número é {menor} e está na posição {posicao_menor}')
  

def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(1,100))
    
    return lista


def verificar_menor(lista):
    menor = float("inf")
    cont = 0
    cont_menor = 0
    for num in lista:
        if num < menor:
            menor = num
            cont_menor = cont
        
        cont += 1
    
    return menor, cont_menor


if __name__ == "__main__":
    main()