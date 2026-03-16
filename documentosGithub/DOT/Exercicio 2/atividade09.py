import random
 
def main():
    qtd_lista = 5
 
    lista_x = grava_lista(qtd_lista)
    print(f"Lista X: {lista_x}")
 
    lista_y = inverter_lista(lista_x)
    print(f"Lista Y (inversa de X): {lista_y}")
 
 
def grava_lista(num):
    lista = []
 
    for _ in range(num):
        lista.append(random.randint(1, 100))
 
    return lista
 
 
def inverter_lista(lista_x):
    lista_y = []
 
    for i in range(len(lista_x) - 1, -1, -1):
        lista_y.append(lista_x[i])
 
    return lista_y
 
 
if __name__ == "__main__":
    main()