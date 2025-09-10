def cadastrar_alunos(notas_alunos):    
    qtd = int(input("Quantos alunos deseja cadastrar? \n>>> "))
    
    for _ in range (qtd):
        nome = input("Nome do(a) aluno(a): ")
        notas = []
      
        for i in range(3):
            nota = float(input(f"Nota {i + 1}: "))
            notas.append(nota)
        
        notas_alunos[nome] = notas
    
    print(f"{qtd} alunos adicionados com sucesso.")

    return notas_alunos
      

def listar_alunos_com_notas(notas_alunos):
    for aluno in notas_alunos:
        print(f'Notas de {aluno}: {notas_alunos[aluno]}')


def calcula_media_alunos(notas_alunos):
    medias_alunos = {}

    for aluno in notas_alunos:
        medias_alunos[aluno] = float(sum(notas_alunos[aluno]) / 3)
    
    for aluno in medias_alunos:
        print(aluno, medias_alunos[aluno])
    
    return medias_alunos


def nomes_alunos_maior_media(medias_alunos):
    maior = max(medias_alunos.values())
    alunos = []

    for aluno in medias_alunos:
        if medias_alunos[aluno] == maior:
            alunos.append(aluno)
    
    return alunos
    

def media_geral_turma(medias):
    return float(sum(medias.values())) / float(len(medias))


def menu(notas_alunos):
    medias = {}  

    while True:
        texto_menu = (
            "1 - Cadastrar aluno\n"
            "2 - Exibir alunos e notas\n"
            "3 - Calcular média de cada aluno\n"
            "4 - Exibir alunos com maior média\n"
            "5 - Calcular média da turma\n"
            "6 - Encerrar programa"
        )
        opcao = int(input(f"Escolha a opção:\n{texto_menu}\n>>> "))

        if opcao == 1:
            notas_alunos = cadastrar_alunos(notas_alunos)
            print("\n")

        elif opcao == 2:
            if notas_alunos:
                listar_alunos_com_notas(notas_alunos)
            else:
                print("Não há alunos cadastrados.\n")

        elif opcao == 3:
            if notas_alunos:
                medias = calcula_media_alunos(notas_alunos)
            else:
                print("Não há alunos cadastrados.\n")

        elif opcao == 4:
            if medias:
                print(f"Alunos com maior média: {nomes_alunos_maior_media(medias)}")
            else:
                print("Ainda não foram calculadas as médias.\n")

        elif opcao == 5:
            if medias:
                print(f"A média geral da turma é {media_geral_turma(medias):.2f}")
            else:
                print("Ainda não foram calculadas as médias.\n")

        elif opcao == 6:
            print("Fim do programa!")
            break

        else:
            print("Opção inválida\n")
    

def main():
    notas_alunos = {}
    menu(notas_alunos)

if __name__ == "__main__":
    main()