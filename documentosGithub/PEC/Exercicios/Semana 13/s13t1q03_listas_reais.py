def main():
    n = int(input())

    lista = lista_invertida(n)
    print(lista)

    if n == 0:
        print([]) 
        print("SEM NOTAS")
  
    else:
        notas, media = calcular_media(n)
        print(notas)
        print(f'{media:.1f}')

    vogais, consoantes = letras(n)

    print(vogais)
    print(consoantes)


def lista_invertida(n):
    lista = []

    for _ in range(n):
        num = float(input())
        lista.insert(0, num)

    return lista


def calcular_media(n):
    notas = []
    soma = 0

    for _ in range(n):
        nota = float(input())
        notas.append(nota)
        soma += nota
    
    media = soma / n

    return notas, media    


def eh_vogal(letra):
    vogais = 'aeiou'

    return letra.lower() in vogais


def letras(num):
    cont_vogais = 0
    consoantes = []

    for _ in range(num):
        letra = input()[0]

        if eh_vogal(letra):
            cont_vogais += 1
        else:
            consoantes.append(letra)
    
    return cont_vogais, consoantes


if __name__ == "__main__":
    main()