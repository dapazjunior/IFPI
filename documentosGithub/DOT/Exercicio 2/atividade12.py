def main():
    qtd_questoes = 30

    gabarito = ler_gabarito(qtd_questoes)
    print(f"\nGabarito: {gabarito}")

    num_alunos = int(input("\nDigite o número de alunos da turma: "))

    for aluno in range(1, num_alunos + 1):
        numero_aluno = int(input(f"\nDigite o número do aluno {aluno}: "))
        respostas = ler_respostas(numero_aluno, qtd_questoes)
        acertos = contar_acertos(gabarito, respostas)
        print(f"Aluno {numero_aluno}: {acertos} acerto(s)")


def ler_gabarito(qtd_questoes):
    gabarito = []

    print("Digite o gabarito (A, B, C, D ou E) para cada questão:")
    for i in range(qtd_questoes):
        while True:
            resposta = input(f"  Questão {i + 1}: ").strip().upper()
            if resposta in ['A', 'B', 'C', 'D', 'E']:
                gabarito.append(resposta)
                break
            else:
                print("  Alternativa inválida. Digite A, B, C, D ou E.")

    return gabarito


def ler_respostas(numero_aluno, qtd_questoes):
    respostas = []

    print(f"Digite as respostas do aluno {numero_aluno}:")
    for i in range(qtd_questoes):
        while True:
            resposta = input(f"  Questão {i + 1}: ").strip().upper()
            if resposta in ['A', 'B', 'C', 'D', 'E']:
                respostas.append(resposta)
                break
            else:
                print("  Alternativa inválida. Digite A, B, C, D ou E.")

    return respostas


def contar_acertos(gabarito, respostas):
    acertos = 0

    for i in range(len(gabarito)):
        if gabarito[i] == respostas[i]:
            acertos += 1

    return acertos


if __name__ == "__main__":
    main()