def main():
    # lê o nome, idade e altura dos alunos
    nomes, idades, alturas = ler_alunos(30)
    
    # verifica quais alunos tem mais de 13 anos e altura menor que a média
    alunos_menores_que_media = verificar(nomes, idades, alturas)

    print("MAIORES DE 13 ANOS COM ALTURA ABAIXO DA MÉDIA")
    for aluno in alunos_menores_que_media:
        print(aluno)


# lê os dados dos alunos
def ler_alunos(qtd):
    nomes = []
    idades = []
    alturas = []

    for _ in range(qtd):
        nome = input().strip()
        nomes.append(nome)

        idade = int(input())
        idades.append(idade)

        altura = float(input())
        alturas.append(altura)

    return nomes, idades, alturas


# verifica os alunos maiores de 13 com altura menor que a média
def verificar(alunos, idades, alturas):
    media = calcular_media(alturas)
    menores = []

    for i in range(len(alunos)):
        if idades[i] > 13:  # verifica se a idade é maior que 13
            if alturas[i] < media:  # verifica se a altura é menor que a média
                menores.append(alunos[i])
    
    return menores


# calcula a média das alturas
def calcular_media(alturas):
    soma = 0
    for altura in alturas:
        soma += altura
    return round((soma / len(alturas)), 2)


if __name__ == "__main__":
    main()
