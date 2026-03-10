import random
def main():
    qtd_lista = 10

    lista = grava_lista(qtd_lista)
    print(lista)

    lista.reverse()
    
    print(lista)
   

def grava_lista(num):
    lista = []

    for _ in range (num):
        lista.append(random.randint(1,100))
    
    return lista


if __name__ == "__main__":
    main()
