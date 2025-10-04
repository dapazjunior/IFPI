class Controle_De_Notas:
    def __init__(self, disciplina, professor, periodo):  # Construtor
        self.notas_alunos = {}
        self.disciplina = disciplina
        self.professor = professor
        self.periodo = periodo

    def cadastar_alunos(self, aluno, notas):
        self.notas_alunos[aluno] = notas


    def listar_alunos_com_notas(self):
        print(">>> Listagem de alunos e notas <<<")
        for aluno in self.notas_alunos:
            print(aluno, self.notas_alunos[aluno])
    

    def listar_notas(self):
        print("\n>>> Informações da Disciplina <<<")
        print(f"Disciplina: {self.disciplina}")
        print(f"Professor: {self.professor}")
        print(f"Período: {self.periodo}")
        print("\n>>> Alunos e Notas <<<")
        if not self.notas_alunos:
            print("Nenhum aluno cadastrado.")
        else:
            cont = 1
            for aluno, notas in self.notas_alunos.items():
                print(f"Aluno {cont}: {aluno} - Notas: {notas}")
                cont += 1

def main():
    controle = Controle_De_Notas()
    controle.cadastar_alunos()
    controle.listar_alunos_com_notas()
    controle.listar_notas()

main()