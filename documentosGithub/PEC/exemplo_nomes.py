def main():
    nomes = [
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda", "Carlos", "Paula", "Rafael",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda", "Carlos", "Paula", "Rafael",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda", "Carlos", "Paula", "Rafael",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda", "Carlos", "Paula",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda", "Carlos",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana", "Fernanda",
    "Ana", "João", "Maria", "Pedro", "Lucas", "Mariana",
    "Ana", "João", "Maria", "Pedro", "Lucas",
    "Ana", "João", "Maria", "Pedro",
    "Ana", "João", "Maria",
    "Ana", "João",
    "Ana"
]

    
    nomes_existentes = verificar_existentes(nomes)
    quantidades = contar(nomes_existentes, nomes)
    
    imprimir(nomes_existentes, quantidades)


def verificar_existentes(lista):
    elementos_existentes = []
    
    for elemento in lista:
        if elemento not in elementos_existentes:
            elementos_existentes.append(elemento)
    
    return elementos_existentes


def contar(elementos, lista):
    quantidades = []

    for i in range(len(elementos)):
        cont = 0

        for item in lista:
            if elementos[i] == item:
                cont += 1
        quantidades.append(cont)
    
    return quantidades


def imprimir(elementos, quantidades):
    for i in range(len(elementos)):
        print(f'{elementos[i]}: {quantidades[i]}')


if __name__ == "__main__":
    main()