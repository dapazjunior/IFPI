import pytest
from controle_de_notas import ControleDeNotas


def test_dados_turma():
    """
    Verifica se o construtor inicializou corretamente os atributos da turma.
    """
    turma = ControleDeNotas("Programação Orientada à Objetos","Rogério","2025.2")
   

    # Verifica se informações da disciplina aparecem
    assert turma.disciplina == "Programação Orientada à Objetos" 
    assert turma.professor=="Rogério"
    assert turma.periodo == "2025.2"


def test_verica_notas_alunos():
    turma= ControleDeNotas("Programação Orientada à Objetos","Rogério","2025.2")

    turma.adicionar_aluno("João", [8.0, 7.5, 9.0])
    turma.adicionar_aluno("Maria", [10.0, 9.5, 9.0])

    assert [8.0, 7.5, 9.0] == turma.notas_alunos['João']
    assert [10.0, 9.5, 9.0] ==  turma.notas_alunos['Maria']


def test_listar_notas_sem_alunos():
    turma = ControleDeNotas("Programação Orientada à Objetos", "Rogério", "2025.2")
    resultado = turma.listar_notas()

    assert resultado == "Nenhum aluno cadastrado!"
    assert len(turma.notas_alunos) == 0


def test_verificar_medias_dos_alunos():
    turma = ControleDeNotas("Programação Orientada à Objetos", "Rogério", "2025.2")
    turma.adicionar_aluno("João", [8.0, 7.5, 9.0])
    turma.adicionar_aluno("Maria", [10.0, 9.5, 9.0])

    medias = turma.calcular_media()
    esperado = {'João': (8.0 + 7.5 + 9.0) / 3, 'Maria': (10.0 + 9.5 + 9.0) / 3}

    assert medias == esperado
    assert len(medias) == 2


def test_verificar_alunos_com_maior_media():
    turma = ControleDeNotas("Programação Orientada à Objetos", "Rogério", "2025.2")
    turma.adicionar_aluno("João", [8.0, 7.5, 9.0])  
    turma.adicionar_aluno("Maria", [10.0, 9.5, 9.0])  
    
    medias = turma.calcular_media()
    maior_media = max(medias.values())

    alunos_com_maior_media = []
    for aluno, media in medias.items():
        if media == maior_media:
            alunos_com_maior_media.append(aluno)
    
    assert maior_media == 9.5
    assert alunos_com_maior_media == ["Maria"]


def test_verificar_alunos_com_maior_media_empate():
    turma = ControleDeNotas("Programação Orientada à Objetos", "Rogério", "2025.2")
    turma.adicionar_aluno("João", [8.0, 7.5, 9.0])  
    turma.adicionar_aluno("Maria", [10.0, 9.5, 9.0])
    turma.adicionar_aluno("José", [10.0, 9.0, 9.5])
    
    medias = turma.calcular_media()
    maior_media = max(medias.values())
    alunos_com_maior_media = []
    for aluno, media in medias.items():
        if media == maior_media:
            alunos_com_maior_media.append(aluno)
    
    assert maior_media == 9.5
    assert alunos_com_maior_media == ["Maria", "José"]