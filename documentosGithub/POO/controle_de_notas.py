class ControleDeNotas:
    def __init__(self,disciplina,professor,periodo):
       self.disciplina = disciplina
       self.professor = professor
       self.periodo = periodo
       self.notas_alunos = {}

    def adicionar_aluno(self, aluno, notas):
        self.notas_alunos[aluno] = notas

    def listar_notas(self):
        print("\n--- Informações da Disciplina ---")
        print(f"Disciplina: {self.disciplina}")
        print(f"Professor: {self.professor}")
        print(f"Período: {self.periodo}")
        print("\n--- Notas dos Alunos ---")
        if not self.notas_alunos:
            return("Nenhum aluno cadastrado!")
        else:
            for aluno, notas in self.notas_alunos.items():
                print(f"{aluno}: {notas}")

    def calcular_media(self):
        medias_alunos = {}
        for aluno, notas in self.notas_alunos.items():
            medias_alunos[aluno] = sum(notas) / len(notas)
            #print(f"Média de {aluno}: {media}")
        return medias_alunos

    def listar_medias(self):
        medias = self.calcular_media()
        if not medias:
          print("Nenhum aluno cadastrado!")
        else:
          print("\n--- Médias dos Alunos ---")
          for aluno, media in medias.items():
              print(f"{aluno}: {media}")

    def alunos_com_maior_media(self):
        medias = self.calcular_media()
        if not medias:
            print("Nenhum aluno cadastrado!")
        else:
            maior_media = max(medias.values())
            alunos_com_maior_media = [aluno for aluno, media in medias.items() if media == maior_media]
            print(f"\nAlunos com a maior média ({maior_media}): {', '.join(alunos_com_maior_media)}")

'''
def main():
    poo = ControleDeNotas("Programação Orientada à Objetos","Prof. Rogério","2025.2")
    poo.adicionar_aluno("João", [8.0, 7.5, 9.0])
    poo.adicionar_aluno("Maria", [10.0, 9.5, 9.0])
    poo.listar_notas()
    poo.listar_medias()
    poo.alunos_com_maior_media()
    banco_de_dados = ControleDeNotas("Banco de Dados","Prof. Fábio","2025.1")
    banco_de_dados.listar_notas()
    banco_de_dados.listar_medias()


main()
'''
