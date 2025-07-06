def main():
    nomes, idades, alturas = ler_alunos(30)
    
    alunos_menores_que_media = verificar(nomes, idades, alturas)

    print("MAIORES DE 13 ANOS COM ALTURA ABAIXO DA MÉDIA")
    for aluno in alunos_menores_que_media:
        print(aluno)


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


def verificar(alunos, idades, alturas):
    media = calcular_media(alturas)
    menores = []

    for i in range(len(alunos)):
        if idades[i] > 13:
            if alturas[i] < media:
                menores.append(alunos[i])
    
    return menores


def calcular_media(alturas):
    soma = 0

    for altura in alturas:
        soma += altura
    
    return round((soma / len(alturas)), 2)


if __name__ == "__main__":
    main()