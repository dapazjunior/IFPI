def main():
    n = int(input())  # lê quantos números/valores vamos trabalhar

    # cria uma lista invertida com os números digitados
    lista = lista_invertida(n)
    print(lista)

    # se n for zero, não tem notas
    if n == 0:
        print([]) 
        print("SEM NOTAS")
    else:
        # senão, lê as notas e calcula a média
        notas, media = calcular_media(n)
        print(notas)
        print(f'{media:.1f}')  # imprime a média com 1 casa decimal

    # lê letras e conta as vogais e guarda as consoantes
    vogais, consoantes = letras(n)
    print(vogais)
    print(consoantes)


# lê números e coloca no começo da lista, deixando ela invertida
def lista_invertida(n):
    lista = []
    for _ in range(n):
        num = float(input())
        lista.insert(0, num)  # insere sempre no início
    return lista


# lê n notas, soma elas e calcula a média
def calcular_media(n):
    notas = []
    soma = 0

    for _ in range(n):
        nota = float(input())
        notas.append(nota)
        soma += nota
    
    media = soma / n  # calcula a média
    return notas, media    


# verifica se a letra é uma vogal
def eh_vogal(letra):
    vogais = 'aeiou'
    return letra.lower() in vogais  # deixa minúscula pra comparar


# lê n letras e separa vogais e consoantes
def letras(num):
    cont_vogais = 0  # contador de vogais
    consoantes = []  # lista pra guardar as consoantes

    for _ in range(num):
        letra = input()[0]  # pega só a primeira letra da entrada

        if eh_vogal(letra):
            cont_vogais += 1
        else:
            consoantes.append(letra)
    
    return cont_vogais, consoantes


if __name__ == "__main__":
    main()
